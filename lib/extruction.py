import os

# الحصول على مسار الدليل الحالي الذي يحتوي على السكربت
current_dir = os.path.dirname(os.path.realpath(__file__))

# دالة لاستعراض المجلدات والملفات على شكل شجرة بشكل محسّن
def print_tree(directory, level=0, prefix=""):
    # استعراض المجلدات والملفات
    try:
        items = os.listdir(directory)
    except PermissionError:
        # في حالة وجود صلاحيات الوصول غير كافية للمجلد
        print(f"{prefix} [مجلد غير قابل للوصول]")
        return

    # تصفية العناصر المخفية (التي تبدأ بـ .)
    items = [item for item in items if not item.startswith('.')]

    # إذا كانت المجلدات أو الملفات فارغة
    if not items:
        print(f"{prefix} [مجلد فارغ]")

    # استعراض العناصر في الدليل
    for i, item in enumerate(items):
        item_path = os.path.join(directory, item)
        # تحديد ما إذا كان العنصر مجلد أو ملف
        is_last_item = i == len(items) - 1
        new_prefix = prefix + ("    " if is_last_item else "│   ")

        if os.path.isdir(item_path):
            # إذا كان مجلدًا، اطبعه مع الرموز
            print(f"{prefix}└── [{item}]")
            # استدعاء الدالة بشكل متكرر للمجلدات الفرعية
            print_tree(item_path, level + 1, new_prefix)
        else:
            # إذا كان ملفًا، اطبعه
            print(f"{prefix}└── {item}")

# استدعاء الدالة للمسار الحالي
print_tree(current_dir)