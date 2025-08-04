const String sampleFormJson = '''
{
  "fields": [
    {
      "id": 1,
      "type": "text",
      "title": "برند:",
      "isRequired": true,
      "content": { "hint": "برند ماشین را وارد کنید" },
      "validation": { "minLen": 2, "maxLen": 30, "type": "plain" }
    },
    {
      "id": 2,
      "type": "text",
      "title": "مدل:",
      "isRequired": true,
      "content": { "hint": "مدل ماشین را وارد کنید" },
      "validation": { "minLen": 1, "maxLen": 40, "type": "plain" }
    },
    {
      "id": 3,
      "type": "select",
      "title": "نوع سوخت:",
      "isRequired": true,
      "content": {
        "hint": "",
        "items": [
          { "id": 1, "label": "بنزین" },
          { "id": 2, "label": "گاز" },
          { "id": 3, "label": "دیزل" },
          { "id": 4, "label": "الکتریکی" }
        ]
      }
    },
    {
      "id": 4,
      "type": "file",
      "title": "تصاویر ماشین:",
      "isRequired": false,
      "content": { "hint": "پذیرش عکس", "multiple": true },
      "validation": { "maxSizeMB": 5 }
    }
  ]
}
''';