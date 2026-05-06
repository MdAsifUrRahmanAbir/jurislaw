import os
import re

def to_pascal_case(text):
    return ''.join(word.capitalize() for word in text.split('_'))

def to_snake_case(text):
    # Handles both PascalCase and camelCase to snake_case
    return re.sub(r'(?<!^)(?=[A-Z])', '_', text).lower()

def find_module_path(module_name):
    base_path = 'lib/app/modules'
    # 1. Try direct path (in case it's like 'auth/login')
    direct_path = os.path.join(base_path, module_name)
    if os.path.exists(direct_path) and os.path.isdir(direct_path):
        return direct_path
    
    # 2. Search recursively for a directory matching the module name
    for root, dirs, files in os.walk(base_path):
        if os.path.basename(root) == module_name:
            return root
    return None

def update_view_file(view_file_path, widget_snake):
    if not os.path.exists(view_file_path):
        print(f"Warning: View file not found at {view_file_path}")
        return

    with open(view_file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    part_directive = f"part '../widgets/{widget_snake}.dart';"
    if part_directive in content:
        return

    # Find the best place to insert the part directive
    lines = content.splitlines()
    last_part_index = -1
    last_import_index = -1
    
    for i, line in enumerate(lines):
        if line.strip().startswith('part '):
            last_part_index = i
        elif line.strip().startswith('import '):
            last_import_index = i

    if last_part_index != -1:
        lines.insert(last_part_index + 1, part_directive)
    elif last_import_index != -1:
        # Check if there is an empty line after imports
        if last_import_index + 1 < len(lines) and lines[last_import_index + 1].strip() == "":
            lines.insert(last_import_index + 2, part_directive)
        else:
            lines.insert(last_import_index + 1, "")
            lines.insert(last_import_index + 2, part_directive)
    else:
        lines.insert(0, part_directive)

    with open(view_file_path, 'w', encoding='utf-8') as f:
        f.write('\n'.join(lines) + '\n')
    print(f"Updated view file: {view_file_path}")

def main():
    # Ask for section/module name
    module_name = input("Enter existing section name (e.g., login): ").strip()
    if not module_name:
        print("Error: Section name cannot be empty.")
        return

    # Ask for widget names
    widgets_input = input("Enter widget names (space separated, e.g., LoginBranding LoginHeader): ").strip()
    if not widgets_input:
        print("No widgets specified.")
        return

    widget_names = widgets_input.split()
    
    # Find the directory
    module_path = find_module_path(module_name)
    if not module_path:
        print(f"Error: Could not find module directory for '{module_name}' under lib/app/modules")
        return

    # Ensure widgets directory exists
    widgets_dir = os.path.join(module_path, 'widgets')
    os.makedirs(widgets_dir, exist_ok=True)
    
    # Infer names
    actual_module_name = os.path.basename(module_path)
    controller_name = f"{to_pascal_case(actual_module_name)}Controller"
    view_file_name = f"{actual_module_name}_view.dart"
    view_file_path = os.path.join(module_path, 'views', view_file_name)
    
    created_widgets = []
    
    for widget_name in widget_names:
        # Normalize widget name
        widget_pascal = to_pascal_case(to_snake_case(widget_name))
        widget_snake = to_snake_case(widget_pascal)
        
        file_path = os.path.join(widgets_dir, f"{widget_snake}.dart")
        
        if os.path.exists(file_path):
            print(f"Skipping: {file_path} already exists.")
            continue
            
        content = f"""part of '../views/{view_file_name}';

class {widget_pascal} extends GetView<{controller_name}> {{
  const {widget_pascal}({{super.key}});

  @override
  Widget build(BuildContext context) {{
    return const SizedBox.shrink();
  }}
}}
"""
        try:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
            created_widgets.append(widget_pascal)
            print(f"Created file: {file_path}")
            
            # Update the view file to include this part
            update_view_file(view_file_path, widget_snake)
            
        except Exception as e:
            print(f"Error creating {widget_name}: {e}")

    # Print created widget names
    if created_widgets:
        print("\nSuccessfully created widgets:")
        for w in created_widgets:
            print(f"- {w}")
    else:
        print("\nNo new widgets were created.")

if __name__ == "__main__":
    main()
