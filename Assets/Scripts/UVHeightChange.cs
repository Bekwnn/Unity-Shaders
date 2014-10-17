using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class UVHeightChange : MonoBehaviour {
	Renderer renderer;
	Color color1A;
	Color color1B;
	Color color2A;
	Color color2B;
	// Use this for initialization
	void Start () {
		renderer = gameObject.GetComponent<Renderer>();
		color1A = new Color (0.2f, 0.8f, 0.0f);
		color1B = new Color (1.0f, 1.0f, 0.3f);
	}
	
	// Update is called once per frame
	void Update () {
		renderer.material.SetFloat("_Softness", (1+Mathf.Sin (Time.time))/2);
	}
}
