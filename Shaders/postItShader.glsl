[VERTEX SHADER]

void main()
{
	gl_Position = ftransform();
	gl_TexCoord[0] = gl_MultiTexCoord0;
}

[FRAGMENT SHADER]

// Texture of the object
uniform sampler2D tex;
uniform float alpha;
uniform vec3 color;

void main()
{
	vec3 colorFromTex = texture2D(tex, gl_TexCoord[0].st).rgb;
    
    if(colorFromTex.r == 1.0 && colorFromTex.g == 1.0 && colorFromTex.b == 1.0)
    	discard;
    
    if(colorFromTex.b > 0.8)
    	colorFromTex = color;
	else
		colorFromTex = vec3(0.0, 1.0, 0.0);
    	
	gl_FragColor = vec4(colorFromTex, alpha);
}
