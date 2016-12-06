#version 400

/* This shader draws the color rectangle in the color picker. Using the rectangle's local coordinate system I
 * normalize the position of each vertex with respect to the size of the rectangle in order to find the correct
 * saturation and value for the given fragment 
 */

[VERTEX SHADER]

varying vec3 position;

void main() 
{
	gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;

	// I pass the vertex position to the shader; I pass the position in world coordinates; To do that I first convert 
	// the vertex into eye-space coordinates, and then apply the inverse
	position = (gl_ModelViewMatrixInverse * (gl_ModelViewMatrix * gl_Vertex)).xyz;
	
	gl_FrontColor = gl_Color;
}

[FRAGMENT SHADER]

uniform float y;    			// Width of the box

varying vec3 position;          // Interpolated position of the vertex, in object space

void main() 
{	
	if(position.y < y)
		gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
	else
		discard;
}