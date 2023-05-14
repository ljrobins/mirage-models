import json
import os


def dict_of_all_files(path: str) -> dict:
    relpath = os.path.relpath(path)
    return {s:dict_of_all_files(os.path.join(path, s))
             if os.path.isdir(os.path.join(path,s)) else os.path.join(relpath,s)
               for s in os.listdir(path) if '.git' not in s}

def _finditem(obj, key):
    if key in obj: return obj[key]
    for k, v in obj.items():
        if isinstance(v,dict):
            item = _finditem(v, key)
            if item is not None:
                return item

def get_model_path(model_name: str) -> str:
    with open('model_listing.json', 'r') as f:
        listing = json.load(f)
    return _finditem(listing, model_name)

    

def main():
    listing_dict = dict_of_all_files(os.getcwd())

    with open('model_listing.json', 'w') as f:
        json.dump(listing_dict, f)

    print(get_model_path('topex.mtl'))

if __name__ == "__main__":
    main()