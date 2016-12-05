#version 400

/* This shader draws the color rectangle in the color picker. Using the rectangle's local coordinate system I
 * normalize the position of each vertex with respect to the size of the rectangle in order to find the correct
 * saturation and value for the given fragment 
 */

[VERTEX SHADER]

varying vec4 position;

void main() 
{
	gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;

	// I pass the vertex position to the shader; note that I'm passing the position in the object's coordinate system
	position = gl_Vertex;
}

[FRAGMENT SHADER]

uniform float width;    			// Width of the box
uniform float height; 				// Height of the box
uniform float hue;                  // Hue of the color

varying vec4 position;              // Interpolated position of the vertex, in object space


/* This function was found on stackoverflow and it's a very common and efficient function for shaders
 *  which converts a color expressed in HSV to RGB. The hue passed to this function must be normalized */
vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}


void main() 
{		
	// I normalizethe hue, because the hsv2rgb function needs it like this
	float normalizedHue = hue / 360.0;
	
	// I compute the value of saturation and value for this fragment, remembering that the rectnagle has its origin
	// in the center while I would like it to be at the top left corner for this computation, so I need to add half the size
	float saturation = (position.x + width / 2.0) / width;
	float value = (position.y + height / 2.0) / height;
	
	// COmputing the resulting color
	vec3 color = hsv2rgb(vec3(normalizedHue, saturation, value));

	gl_FragColor = vec4(color, 1.0);
}