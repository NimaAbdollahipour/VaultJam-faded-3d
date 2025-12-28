using UnityEngine;
using System.IO;

/// <summary>
/// Manages game save data and level progression.
/// Singleton pattern - persists across scenes.
/// </summary>
public class SaveManager : MonoBehaviour
{
    public static SaveManager Instance { get; private set; }

    private string savePath;
    public string currentLevelPath = "Level1";

    [System.Serializable]
    public class SaveData
    {
        public string level;
    }

    void Awake()
    {
        // Singleton pattern
        if (Instance == null)
        {
            Instance = this;
            DontDestroyOnLoad(gameObject);
            savePath = Path.Combine(Application.persistentDataPath, "savegame.json");
            LoadGame();
        }
        else
        {
            Destroy(gameObject);
        }
    }

    public void SaveGame(string levelPath)
    {
        Debug.Log("Saving game: " + levelPath);
        currentLevelPath = levelPath;

        SaveData data = new SaveData { level = levelPath };
        string json = JsonUtility.ToJson(data);

        File.WriteAllText(savePath, json);
    }

    public void LoadGame()
    {
        if (!File.Exists(savePath))
        {
            Debug.Log("No save file found.");
            return;
        }

        string json = File.ReadAllText(savePath);
        SaveData data = JsonUtility.FromJson<SaveData>(json);

        if (data != null && !string.IsNullOrEmpty(data.level))
        {
            currentLevelPath = data.level;
            Debug.Log("Loaded game: " + currentLevelPath);
        }
    }

    public bool HasSave()
    {
        return File.Exists(savePath);
    }

    public void ClearSave()
    {
        if (File.Exists(savePath))
        {
            File.Delete(savePath);
        }
        currentLevelPath = "Level1";
    }
}
