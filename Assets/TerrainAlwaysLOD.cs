using UnityEngine;
using System.Collections;

public class TerrainAlwaysLOD : MonoBehaviour {

	void Start () {
		Terrain.activeTerrain.heightmapMaximumLOD = 0;
	}
}
