/*  ___| |__   __ _  __| | _____      __  _ __ ___   __ _ _ __  v.02
 * / __| '_ \ / _` |/ _` |/ _ \ \ /\ / / | '_ ` _ \ / _` | '_ \/ __|
 * \__ \ | | | (_| | (_| | (_) \ V  V /  | | | | | | (_| | |_) \__ \
 * |___/_| |_|\__,_|\__,_|\___/ \_/\_/   |_| |_| |_|\__,_| .__/|___/
 * XVR tutorial example on shadow mapping                |_|jul 2006
 *
 * Need help with this code? Please contact:
 *  - http://wiki.vrmedia.it
 *  - http://forums.vrmedia.it
 */

[VERTEX SHADER]

void pointLight()
{
	int i = 0; // light index
	
	// Compute vector from surface to light position
	vec3 VP = normalize(vec3(gl_LightSource[i].position - gl_ModelViewMatrix * gl_Vertex));

	float nDotVP, nDotHV;
	{
		// Compute the normal in eye coordinates
		vec3 normal = normalize(gl_NormalMatrix * gl_Normal);

		// Draw also back facing surfaces (for the tree)		
		if (dot(normal, VP) < 0.0)
			normal = -normal;

		// normal . light direction
		nDotVP = max(0.0, dot(normal, VP));

		// direction of maximum highlights (eye)
		vec3 halfVector = normalize(VP + vec3(0.0, 0.0, 1.0));
		
		// normal . light half vector
		nDotHV = max(0.0, dot(normal, halfVector));
	}

	// power factor
	float pf = (nDotVP == 0.0) ? 0.0 : pow(nDotHV, gl_FrontMaterial.shininess);

	// Ambient
	vec4 color = gl_FrontMaterial.ambient * gl_LightSource[i].ambient;

	// Diffuse
	color += gl_FrontMaterial.diffuse * vec4(1.0, 223.0/255.0, 240.0/255.0, 1.0) * nDotVP;

	// Specular
	color += gl_FrontMaterial.specular * gl_LightSource[i].specular * pf;

	float attenuation;
	{
		// Compute distance between surface and light position
		float d = length(VP);
	
		// Compute attenuation
		attenuation = 1.0 / (gl_LightSource[i].constantAttenuation +
			d * (gl_LightSource[i].linearAttenuation + d * gl_LightSource[i].quadraticAttenuation));
	}

	gl_FrontColor = clamp(color * attenuation + gl_FrontLightModelProduct.sceneColor, 0.0, 1.0);
}

uniform mat4 mvp;

varying float help;

void main (void)
{
	// vertex calculation
	gl_Position = ftransform();

	// color calculations
//	pointLight();

	// shadow texture coordinates generation
 //	gl_TexCoord[1] = gl_TextureMatrix[0] * gl_ModelViewMatrix * gl_Vertex;
  	gl_TexCoord[1] = mvp * gl_ModelViewMatrix * gl_Vertex;
	
	gl_TexCoord[0] = gl_MultiTexCoord0;
}

[FRAGMENT SHADER]

uniform sampler2D tex;
uniform sampler2DShadow shadowMap;

varying float help;

bool is_out(vec4 coor)
{
	coor = coor / coor.q; // projection
	
	return any(notEqual(coor.st, clamp(coor.st, 0.0, 1.0)));
}

void main(void)
{
//	vec4 orig_color = gl_Color * texture2D(tex, gl_TexCoord[0].st);
	vec4 orig_color = texture2D(tex, gl_TexCoord[0].st);
	
	if(help == 1.0)
		orig_color = vec4(0.6, 0.0, 0.0, 1.0);

	if (is_out(gl_TexCoord[1]) || shadow2DProj(shadowMap, gl_TexCoord[1]).r == 1.0)
		gl_FragColor = orig_color;
	else
		gl_FragColor = vec4(vec3(0.0, 0.0, 0.0) + orig_color.xyz * 0.5, orig_color.a);
}
