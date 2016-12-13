[VERTEX SHADER]

void main()
{
	gl_Position = ftransform();
	gl_TexCoord[0] = gl_MultiTexCoord0;
}

[FRAGMENT SHADER]

// Texture of the object
uniform sampler2D tex;

void main()
{
//	vec3 colorFromTex = texture2D(tex, gl_TexCoord[0].st).rgb;
	
//	gl_FragColor = vec4(colorFromTex, 1.0);
	
	float depthValue = texture2D(tex, gl_TexCoord[0].st).r;
	
	if(depthValue == 1.0)
		gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
	else
    gl_FragColor = vec4(vec3(depthValue), 1.0);
}
