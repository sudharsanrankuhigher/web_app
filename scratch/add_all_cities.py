import json
import os

def main():
    json_path = os.path.join('assets', 'json', 'cities.json')
    if not os.path.exists(json_path):
        print(f"Error: Could not find {json_path}")
        return

    with open(json_path, 'r', encoding='utf-8') as f:
        try:
            data = json.load(f)
        except Exception as e:
            print(f"Error reading JSON: {e}")
            return

    # Find all unique states and identify which ones already have "All"
    states = set()
    states_with_all = set()
    max_id = 0

    for item in data:
        state = item.get('state')
        name = item.get('name')
        try:
            item_id = int(item.get('id', 0))
            if item_id > max_id:
                max_id = item_id
        except ValueError:
            pass
        
        if state:
            states.add(state)
            if name == 'All':
                states_with_all.add(state)

    print(f"Total unique states found: {len(states)}")
    print(f"States already having 'All': {len(states_with_all)}")
    print(f"Current maximum ID: {max_id}")

    # Generate new entries for states that don't have "All"
    next_id = max_id + 1
    new_entries = []
    
    # Sort states to have deterministic output
    for state in sorted(states):
        if state not in states_with_all:
            new_entry = {
                "id": str(next_id),
                "name": "All",
                "state": state
            }
            new_entries.append(new_entry)
            print(f"Adding 'All' for state: {state} with ID: {next_id}")
            next_id += 1

    if not new_entries:
        print("No new 'All' entries needed. All states already have an 'All' entry.")
        return

    # Insert new entries at the beginning of the list
    updated_data = new_entries + data

    # Write back to cities.json
    try:
        with open(json_path, 'w', encoding='utf-8') as f:
            json.dump(updated_data, f, indent=4)
        print(f"Successfully updated {json_path}. Added {len(new_entries)} new entries.")
    except Exception as e:
        print(f"Error writing to JSON: {e}")

if __name__ == '__main__':
    main()
