const String sampleFormJson = '''
{
  "fields": [
    {
      "id": 1,
      "type": "text",
      "title": "Brand:",
      "isRequired": true,
      "content": { "hint": "Enter the car brand" },
      "validation": { "minLen": 2, "maxLen": 30, "type": "plain" }
    },
    {
      "id": 2,
      "type": "text",
      "title": "Model:",
      "isRequired": true,
      "content": { "hint": "Enter the car model" },
      "validation": { "minLen": 1, "maxLen": 4, "type": "plain" }
    },
    {
      "id": 3,
      "type": "select",
      "title": "Fuel Type:",
      "isRequired": true,
      "content": {
        "hint": "Select",
        "items": [
          { "id": 1, "label": "Gasoline" },
          { "id": 2, "label": "Gas" },
          { "id": 3, "label": "Diesel" },
          { "id": 4, "label": "Electric" }
        ]
      }
    },
    {
      "id": 4,
      "type": "file",
      "title": "Car Images:",
      "isRequired": false,
      "content": { "hint": "Accept image" },
      "validation": { "allowedType": "jpg" }
    }
  ]
}
''';