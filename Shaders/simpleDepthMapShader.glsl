[VERTEX SHADER]

uniform mat4 lightSpaceMatrix;
uniform mat4 modelMatrix;

void main(void)
{
	gl_Position = lightSpaceMatrix * modelMatrix * gl_Vertex;
}

[FRAGMENT SHADER]


void main(void)
{
	gl_FragDepth = gl_FragCoord.z;
}
