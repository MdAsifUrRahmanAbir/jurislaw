import os
import re
import subprocess

def to_camel_case(text):
    # If it ends with 'Model', remove it for the method/variable name part
    if text.endswith('Model'):
        text = text[:-5]
    if not text:
        return ""
    return text[0].lower() + text[1:]

def to_pascal_case(text):
    return text[0].upper() + text[1:]

def copy_to_clipboard(text):
    try:
        process = subprocess.Popen('clip', stdin=subprocess.PIPE, shell=True)
        process.communicate(input=text.encode('utf-8'))
        return True
    except Exception as e:
        print(f"Error copying to clipboard: {e}")
        return False

def main():
    print("--- API Boilerplate Generator ---")
    
    model_name = input("Enter Model Name (e.g., SendOtpModel): ").strip()
    if not model_name:
        print("Error: Model name is required.")
        return

    # Infer method name
    suggested_method = to_camel_case(model_name)
    method_name = input(f"Enter Method Name (default: {suggested_method}): ").strip() or suggested_method
    
    api_endpoint = input("Enter API Endpoint (e.g., ApiEndpoint.sendOtpUrl): ").strip()
    if not api_endpoint:
        print("Error: API Endpoint is required.")
        return

    http_method = input("Enter HTTP Method (get, post, put) [default: post]: ").strip().lower() or "post"
    
    # Naming conventions
    var_name = to_camel_case(model_name) + "Model"
    
    loading_suggested = f"_is{to_pascal_case(method_name)}Loading"
    loading_var = input(f"Enter Loading Var Name (default: {loading_suggested}): ").strip() or loading_suggested
    
    if loading_var.startswith('_'):
        loading_getter = loading_var[1:]
    else:
        loading_getter = "is" + to_pascal_case(loading_var)

    code = f"""  /// ---- {to_pascal_case(method_name)} API
  final {loading_var} = false.obs;
  bool get {loading_getter} => {loading_var}.value;

  {model_name} get {var_name} => _{var_name};
  late {model_name} _{var_name} ;

  Future<{model_name}?> {method_name}() async {{
    // if (!formKey.currentState!.validate()) return null;
    {loading_var}.value = true;
    update();

    try {{
      final response = await ApiServices.{http_method}<{model_name}>(
        {model_name}.fromJson,
        {api_endpoint},
        body: {{
          'key': 'value',
        }},
        showSuccessMessage: true,
        isBasic: true,
      );

      if (response != null) {{
        _{var_name} = response;
        // TODO: Implement success logic
      }}
      return response;
    }} catch (e) {{
      AppSnackBar.error(e.toString());
    }} finally {{
      {loading_var}.value = false;
      update();
    }}
    return null;
  }}
"""

    print("\nGenerated Code:\n")
    print("-" * 40)
    print(code)
    print("-" * 40)
    
    if copy_to_clipboard(code):
        print("\nSUCCESS: Code copied to clipboard!")
    else:
        print("\nFAILED: Could not copy to clipboard. Please copy it manually from the terminal.")

if __name__ == "__main__":
    main()
