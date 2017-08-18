Example usage of normalized field in aggregation
Tested in Elasticsearch v5.5.0

#### Mapping
```
PUT normalizer_test
{
    "settings": {
    "analysis": {
      "normalizer": {
        "lowercase_normalizer": {
          "type": "custom",
          "filter": ["lowercase"]
        }
      }
    }
  }, 
   "mappings": {
      "data": {
         "_all": {
            "enabled": false
         },
         "properties": {
            "time": {
               "type": "date"
            },
            "text_field": {
               "type": "keyword",
               "copy_to": "text_lowercase"
            },
            "text_field_lowercase": {
               "type": "keyword",
               "normalizer": "lowercase_normalizer"
            },
            "double_field": {
               "type": "double"
            }
         }
      }
   }
}
```

#### Get Mapping
```
GET normalizer_test/_mapping
```

#### Index data
```
PUT normalizer_test/data/1
{
    "double_field": 1,
    "text_keyword": "rAVi",
    "time": "2017-08-01T06:44:55.837Z"
}

PUT normalizer_test/data/2
{
    "double_field": 2,
    "text_keyword": "RavI",
    "time": "2017-08-02T06:44:55.837Z"
}

PUT normalizer_test/data/3
{
    "double_field": 3,
    "text_keyword": "TeJa",
    "time": "2017-08-03T06:44:55.837Z"
}

PUT normalizer_test/data/4
{
    "double_field": 4,
    "text_keyword": "teja",
    "time": "2017-08-04T06:44:55.837Z"
}
```

#### Query on normalized field
```
GET normalizer_test/_search
{
    "size": 20,
    "aggs": {
        "terms": {
            "terms": {
                "field": "text_keyword_lowercase"
            }
        }
    }
}
```
