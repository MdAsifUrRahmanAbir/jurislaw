import os
import re
import sys

def to_pascal_case(text):
    return ''.join(word.capitalize() for word in text.split('_'))

def to_camel_case(text):
    pascal = to_pascal_case(text)
    return pascal[0].lower() + pascal[1:]

def to_snake_case(text):
    return re.sub(r'(?<!^)(?=[A-Z])', '_', text).lower()

def create_file(path, content):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, 'w', encoding='utf-8') as f:
        f.write(content)
    print(f"Created: {path}")

def update_routes(category, screen_name_snake):
    screen_name_pascal = to_pascal_case(screen_name_snake)
    screen_name_camel = to_camel_case(screen_name_snake)
    
    app_routes_path = 'lib/app/routes/app_routes.dart'
    app_pages_path = 'lib/app/routes/app_pages.dart'
    
    # 1. Update app_routes.dart
    with open(app_routes_path, 'r', encoding='utf-8') as f:
        routes_lines = f.readlines()
    
    route_const = f"  static const {screen_name_camel} = '/{screen_name_snake}';\n"
    
    # Check if route already exists
    if any(f" {screen_name_camel} =" in line for line in routes_lines):
        print(f"Skipping app_routes.dart: Route {screen_name_camel} already exists.")
    else:
        # Insert before last closing bracket
        for i in range(len(routes_lines) - 1, -1, -1):
            if '}' in routes_lines[i]:
                routes_lines.insert(i, route_const)
                break
        with open(app_routes_path, 'w', encoding='utf-8') as f:
            f.writelines(routes_lines)
        print(f"Updated: {app_routes_path}")

    # 2. Update app_pages.dart
    with open(app_pages_path, 'r', encoding='utf-8') as f:
        pages_content = f.readlines()
    
    if category:
        module_path = f"../modules/{category}/{screen_name_snake}"
    else:
        module_path = f"../modules/{screen_name_snake}"
        
    binding_import = f"import '{module_path}/bindings/{screen_name_snake}_binding.dart';\n"
    view_import = f"import '{module_path}/views/{screen_name_snake}_view.dart';\n"
    
    # Check if imports already exist
    if view_import in pages_content:
        print(f"Skipping app_pages.dart: Imports for {screen_name_snake} already exist.")
    else:
        # Add imports at top (after existing imports)
        last_import_index = 0
        for i, line in enumerate(pages_content):
            if line.startswith('import '):
                last_import_index = i
        pages_content.insert(last_import_index + 1, binding_import)
        pages_content.insert(last_import_index + 2, view_import)
        
        # Add GetPage entry
        get_page_entry = f"""    GetPage(
      name: Routes.{screen_name_camel},
      page: () => const {screen_name_pascal}View(),
      binding: {screen_name_pascal}Binding(),
      transition: Transition.rightToLeft,
    ),\n"""
        
        # Insert before the last closing bracket of the routes list
        for i in range(len(pages_content) - 1, -1, -1):
            if '];' in pages_content[i]:
                pages_content.insert(i, get_page_entry)
                break
                
        with open(app_pages_path, 'w', encoding='utf-8') as f:
            f.writelines(pages_content)
        print(f"Updated: {app_pages_path}")

def main():
    if len(sys.argv) >= 3:
        screen_input = sys.argv[1]
        category_input = sys.argv[2]
    elif len(sys.argv) == 2:
        screen_input = sys.argv[1]
        category_input = ""
    else:
        screen_input = input("Enter Module Name (e.g., test_section): ").strip()
        category_input = input("Enter Category (Leave empty if direct in lib/app/modules/): ").strip()

    # Normalize names
    screen_snake = to_snake_case(screen_input).replace(' ', '_')
    screen_pascal = to_pascal_case(screen_snake)
    category = category_input.lower().strip()

    if category:
        base_path = f"lib/app/modules/{category}/{screen_snake}"
    else:
        base_path = f"lib/app/modules/{screen_snake}"
    
    # Directories
    os.makedirs(f"{base_path}/bindings", exist_ok=True)
    os.makedirs(f"{base_path}/controllers", exist_ok=True)
    os.makedirs(f"{base_path}/views", exist_ok=True)
    os.makedirs(f"{base_path}/widgets", exist_ok=True)

    # Controller
    controller_content = f"""import 'package:get/get.dart';

class {screen_pascal}Controller extends GetxController {{
  final count = 0.obs;

  @override
  void onInit() {{
    super.onInit();
  }}

  @override
  void onReady() {{
    super.onReady();
  }}

  @override
  void onClose() {{
    super.onClose();
  }}

  void increment() => count.value++;
}}
"""
    create_file(f"{base_path}/controllers/{screen_snake}_controller.dart", controller_content)

    # Binding
    binding_content = f"""import 'package:get/get.dart';
import '../controllers/{screen_snake}_controller.dart';

class {screen_pascal}Binding extends Bindings {{
  @override
  void dependencies() {{
    Get.lazyPut<{screen_pascal}Controller>(
      () => {screen_pascal}Controller(),
    );
  }}
}}
"""
    create_file(f"{base_path}/bindings/{screen_snake}_binding.dart", binding_content)

    # Main View (View Switcher)
    view_content = f"""import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/{screen_snake}_controller.dart';

part '{screen_snake}_mobile.dart';
part '{screen_snake}_tab.dart';

class {screen_pascal}View extends GetView<{screen_pascal}Controller> {{
  const {screen_pascal}View({{super.key}});

  @override
  Widget build(BuildContext context) {{
    return LayoutBuilder(
      builder: (context, constraints) {{
        if (constraints.maxWidth > 600) {{
          return const {screen_pascal}Tab();
        }}
        return const {screen_pascal}Mobile();
      }},
    );
  }}
}}
"""
    create_file(f"{base_path}/views/{screen_snake}_view.dart", view_content)

    # Mobile View
    mobile_content = f"""part of '{screen_snake}_view.dart';

class {screen_pascal}Mobile extends GetView<{screen_pascal}Controller> {{
  const {screen_pascal}Mobile({{super.key}});

  @override
  Widget build(BuildContext context) {{
    return Scaffold(
      appBar: AppBar(
        title: const Text('{screen_pascal}View'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          '{screen_pascal} is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }}
}}
"""
    create_file(f"{base_path}/views/{screen_snake}_mobile.dart", mobile_content)

    # Tab View
    tab_content = f"""part of '{screen_snake}_view.dart';

class {screen_pascal}Tab extends GetView<{screen_pascal}Controller> {{
  const {screen_pascal}Tab({{super.key}});

  @override
  Widget build(BuildContext context) {{
    return Scaffold(
      appBar: AppBar(
        title: const Text('{screen_pascal}View'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          '{screen_pascal} is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }}
}}
"""
    create_file(f"{base_path}/views/{screen_snake}_tab.dart", tab_content)

    # Update Routes
    try:
        update_routes(category, screen_snake)
    except Exception as e:
        print(f"Error updating routes: {e}")

    print(f"\nGeneration of module '{screen_snake}' complete!")

if __name__ == "__main__":
    main()
