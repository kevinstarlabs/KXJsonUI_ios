{  
  "layout": {    
      "name": "root",
      "widget": "KXLinearLayout",
      "ios_auto_edge": true,
      "attr": [
        {
          "name": "size",
          "value": {
            "width": "match_parent",
            "height": "match_parent"
          }
        },
        {
          "name": "orientation",
          "value": "vertical"
        },
        {
          "name": "color",
          "value": "#ffffff"
        }
      ],
      "subviews": [
        {    
          "name": "",
          "widget": "KXLinearLayout",
          "attr": [
            {
              "name": "size",
              "value": {
                "width": "match_parent",
                "height": "auto"
              }
            },
            {
              "name": "orientation",
              "value": "horizontal"
            },
            {
              "name": "color",
              "value": "clear"
            },
            {
              "name": "weight",
              "value": 5
            }
          ],
          "subviews":[
            {
              "name":"",
              "widget":"UIImageView",
              "attr":[
                {
                  "name": "size",
                  "value": {
                    "width": "auto",
                    "height": "match_parent"
                  }
                },
                {
                  "name":"image",
                  "value":"p1.jpg"
                },
                {
                  "name":"content_mode",
                  "value":"aspect_fit"
                },
                {
                  "name": "weight",
                  "value": 1
                },
                {
                  "name": "margins",
                  "value": {
                    "left": "8dp",
                    "top": "8dp",
                    "right": "4dp",
                    "bottom": "8dp"
                  }
                }
              ]
            },
            {
              "name":"",
              "widget":"UIImageView",
              "attr":[
                {
                  "name": "size",
                  "value": {
                    "width": "auto",
                    "height": "match_parent"
                  }
                },
                {
                  "name":"image",
                  "value":"p2.jpg"
                },
                {
                  "name":"content_mode",
                  "value":"aspect_fit"
                },
                {
                  "name": "weight",
                  "value": 1
                },
                {
                  "name": "margins",
                  "value": {
                    "left": "4dp",
                    "top": "8dp",
                    "right": "8dp",
                    "bottom": "8dp"
                  }
                }
              ]
            }
          ]
        },
        {
          "name": "",
          "widget": "UILabel",
          "attr": [
            {
              "name": "size",
              "value": {
                "width": "match_parent",
                "height": "auto"
              }
            },
            {
              "name": "color",
              "value": "#e8f7d5"
            },
            {
              "name": "weight",
              "value": 1
            },
            {
              "name": "text",
              "value": "What a beautiful scenery!"
            },
            {
              "name": "text_color",
              "value": "#185ca3"
            },
            {
              "name": "margins",
              "value": {
                "left": "4dp",
                "top": "4dp",
                "right": "4dp",
                "bottom": "4dp"
              }
            },
            {
              "name": "gravity",
              "value": "center"
            },
            {
              "name":"text_align",
              "value":"left"
            },
            {
              "name": "font_size",
              "value": "24dp"
            }
          ]
        },
        {
          "name": "",
          "widget": "UILabel",
          "attr": [
            {
              "name": "size",
              "value": {
                "width": "match_parent",
                "height": "auto"
              }
            },
            {
              "name": "color",
              "value": "clear"
            },
            {
              "name": "weight",
              "value": 1
            },
            {
              "name": "text",
              "value": "Keep calm and enjoy nature."
            },
            {
              "name": "text_color",
              "value": "#808080"
            },
            {
              "name": "margins",
              "value": {
                "left": "4dp",
                "top": "2dp",
                "right": "4dp",
                "bottom": "2dp"
              }
            },
            {
              "name": "gravity",
              "value": "center"
            },
            {
              "name":"text_align",
              "value":"right"
            },
            {
              "name": "font_size",
              "value": "12dp"
            }
          ]
        },
        {
          "name": "button1",
          "widget": "UIButton",
          "attr": [
            {
              "name": "size",
              "value": {
                "width": "match_parent",
                "height": "45dp"
              }
            },
            {
              "name": "weight",
              "value": 0
            },
            {
              "name": "gravity",
              "value": "center"
            },            
            {
              "name": "text",
              "value": "Click here to change layout"
            },
            {
              "name": "font_size",
              "value": "17dp"
            },
            {
              "name": "text_color",
              "value": "#ffffff"
            },
            {
              "name": "color",
              "value": "#0000ff"
            },
            {
              "name": "font_fit",
              "value": true
            },
            {
              "name": "margins",
              "value": {
                "left": "0dp",
                "top": "0dp",
                "right": "0dp",
                "bottom": "0dp"
              }
            }
          ]
        }
      ]    
  }
}
