import json
import os


def dict_of_all_files(path: str) -> dict:
    relpath = os.path.relpath(path)
    return {s:dict_of_all_files(os.path.join(path, s))
             if os.path.isdir(os.path.join(path,s)) else os.path.join(relpath,s)
               for s in os.listdir(path) if '.git' not in s}
        

def main():
    listing_dict = dict_of_all_files(os.getcwd())
    with open('model_listing.json', 'w') as f:
        json.dump(listing_dict, f)

if __name__ == "__main__":
    main()