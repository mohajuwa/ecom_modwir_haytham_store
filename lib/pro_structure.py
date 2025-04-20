##########################################################################################

##########################################################################################

               # ModWir , Copyrites


##########################################################################################

##########################################################################################

import os

def create_structure():
    # Define the base structure
    structure = {
        "bindings": [],
        "controller": [],
        "core": [
            "class",
            "constant",
            "functions",
            "localization",
            "middleware",
            "services",
            "shared",
        ],
        "data": [
            "datasource",
            "model",
        ],
        "view": [
            "address",
            "screen",
            "widget",
        ],
    }

    # Files to be created in the base directory
    files = ["linkapi.dart", "routes.dart"]

    # Get the script directory
    base_dir = os.path.dirname(os.path.abspath(__file__))

    print(f"Base directory: {base_dir}")

    # Create folders and subfolders
    for folder, subfolders in structure.items():
        folder_path = os.path.join(base_dir, folder)
        os.makedirs(folder_path, exist_ok=True)
        print(f"Created folder: {folder_path}")

        for subfolder in subfolders:
            subfolder_path = os.path.join(folder_path, subfolder)
            os.makedirs(subfolder_path, exist_ok=True)
            print(f"Created subfolder: {subfolder_path}")

    # Create files in the base directory
    for file in files:
        file_path = os.path.join(base_dir, file)
        if not os.path.exists(file_path):
            with open(file_path, "w") as f:
                f.write("")  # Create an empty file
            print(f"Created file: {file_path}")

if __name__ == "__main__":
    create_structure()