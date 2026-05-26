import os
import re

files_to_update = [
    r"lib\ui\views\users\widgets\user_table_source.dart",
    r"lib\ui\views\report\widgets\table_source\company_detailed_table_source.dart",
    r"lib\ui\views\report\widgets\table_source\company_table_source.dart",
    r"lib\ui\views\report\widgets\table_source\inf_report_table_source.dart",
    r"lib\ui\views\report\widgets\table_source\subscription_report_table_source.dart",
    r"lib\ui\views\report\widgets\table_source\inf_highlight_table_source.dart",
    r"lib\ui\views\report\widgets\table_source\client_detailed_table_source.dart",
    r"lib\ui\views\state\widget\State_table_source.dart",
    r"lib\ui\views\sub_admin\widgets\sub_admin_table_source.dart",
    r"lib\ui\views\services\widgets\service_table_source.dart",
    r"lib\ui\views\roles\widgets\roles_table_source.dart",
    r"lib\ui\views\promote_projects\widgets\promote_table_source.dart",
    r"lib\ui\views\promote_projects\widgets\project_table_source.dart",
    r"lib\ui\views\requests\widgets\request_table_source.dart",
    r"lib\ui\views\plans\widgets\plans_table_source.dart",
    r"lib\ui\views\location_contact\widgets\contact_table_source.dart",
    r"lib\ui\views\influencers\widgets\influencers_table_source.dart",
    r"lib\ui\views\contact_support\widget\contact_client_table_source.dart",
    r"lib\ui\views\city\widget\city_table_source.dart",
    r"lib\ui\views\banner\widgtes\banner_table_source.dart",
    r"lib\ui\views\add_company\widgets\company_table_source.dart",
]

import_statement = "import 'package:webapp/services/theme_service.dart';"

new_color_block = """          final isDark = ThemeService.instance.isDarkMode;
          if (isDark) {
            return index.isEven ? const Color(0xFF1E293B) : const Color(0xFF0F172A);
          }
          return index.isEven ? Colors.white : Colors.grey.shade100;"""

pattern_arrow = re.compile(
    r"\(\w*states\w*\)\s*=>\s*index\.isEven\s*\?\s*Colors\.white\s*:\s*Colors\.grey\.shade100"
)

pattern_block = re.compile(
    r"\(\s*(Set<\w+>\s+)?\w+\s*\)\s*\{\s*if\s*\(\s*index\.isEven\s*\)\s*return\s*Colors\.white\s*;\s*return\s*Colors\.grey\.shade100\s*;\s*\}"
)

pattern_sub_admin = re.compile(
    r"return\s+index\.isEven\s*\?\s*Colors\.white\s*:\s*Colors\.grey\.shade100\s*;"
)

for file_path in files_to_update:
    if not os.path.exists(file_path):
        print(f"File not found: {file_path}")
        continue
        
    with open(file_path, "r", encoding="utf-8") as f:
        content = f.read()
        
    updated = False
    
    # 1. Add import
    if import_statement not in content:
        lines = content.splitlines()
        inserted = False
        for idx, line in enumerate(lines):
            if line.startswith("import '"):
                lines.insert(idx + 1, import_statement)
                inserted = True
                break
        if not inserted:
            lines.insert(0, import_statement)
        content = "\n".join(lines)
        updated = True
        
    # 2. Replace alternating color pattern
    if pattern_arrow.search(content):
        content = pattern_arrow.sub(
            "(states) {\n" + new_color_block + "\n        }",
            content
        )
        updated = True
        print(f"Updated arrow pattern in: {file_path}")
    elif pattern_block.search(content):
        content = pattern_block.sub(
            "(states) {\n" + new_color_block + "\n        }",
            content
        )
        updated = True
        print(f"Updated block pattern in: {file_path}")
    elif pattern_sub_admin.search(content):
        content = pattern_sub_admin.sub(
            new_color_block,
            content
        )
        updated = True
        print(f"Updated sub_admin return pattern in: {file_path}")
    else:
        print(f"No matching color pattern found in: {file_path}")
        
    if updated:
        with open(file_path, "w", encoding="utf-8", newline="\n") as f:
            f.write(content)

print("Done updating all table files.")
