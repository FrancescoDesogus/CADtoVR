#version 400

[VERTEX SHADER]

varying vec3 position;

void main() 
{
	gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
	
	// I pass the vertex position to the shader; I pass the position in world coordinates; To do that I first convert 
	// the vertex into eye-space coordinates, and then apply the inverse
	//position = (gl_ModelViewMatrixInverse * (gl_ModelViewMatrix * gl_Vertex)).xyz;
	position = (gl_ModelViewMatrix * gl_Vertex).xyz;
}

[FRAGMENT SHADER]

uniform vec3 sourcePoint;   // Origin of the line
uniform float lineLength;   // Total length of the line
uniform vec3 color;         // Color of the line
uniform float ticksLength;  // Length of the ticks
uniform float offset;       //Offset of the ticks' positions; it's used to create the illusion that they're moving

varying vec3 position;      // Interpolated position of the vertex, in world space

void main() 
{	// I compute the distance, but this time taking into account the offset, so that it changes from frame to frame along with the offset, 
    // making it look like the ticks are moving
	float dist = lineLength - offset;
	
	// I compute where is the fragment in the line, taking into account the offset
	float currentDist = distance(sourcePoint, position) - offset;
	
	// I compute the ticks number according to the distance and the length of the ticks; I then divide by 2 because I need NOT to take into account the empty spaces
	float ticksNumber = ceil((dist / ticksLength) / 2.0);
	
	// I compute in which "bin" this fragment belongs to; I do that by taking its position in the line and dividing it by the length of a tick
	float currentBin = round(currentDist / ticksLength);
	
	// I take the modulo of the bin: if the result is 1, it's a tick; if it's 0, it's an invisible part of the line, so I discard the fragment
	if(mod(currentBin,  2.0) != 0.0) 
	    gl_FragColor = vec4(color, 1.0);
	else 
    	discard;
}