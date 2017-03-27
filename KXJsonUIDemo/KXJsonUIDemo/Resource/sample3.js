{  
  "layout": {    
      "name": "root",
      "widget": "KXRelativeLayout",
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
          "name": "color",
          "value": "#ffffff"
        }
      ],
      "subviews": [
        {
          "name":"image1",
          "widget":"UIImageView",
          "attr":[
            {
              "name": "size",
              "value": {
                "width": "200dp",
                "height": "150dp"
              }
            },
            {
              "name":"image",
              "value":"p3.jpg"
            },
            {
              "name":"content_mode",
              "value":"aspect_fit"
            },            
            {
              "name": "margins",
              "value": {
                "left": "0dp",
                "top": "0dp",
                "right": "0dp",
                "bottom": "0dp"
              }
            },
            {
              "name":"align_parent_center",
              "value": true
            }
          ]
        },
        {
          "name":"image2",
          "widget":"UIImageView",
          "attr":[
            {
              "name": "size",
              "value": {
                "width": "100dp",
                "height": "75dp"
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
              "name": "margins",
              "value": {
                "left": "0dp",
                "top": "0dp",
                "right": "0dp",
                "bottom": "0dp"
              }
            },
            {
              "name":"align_right",
              "value": "image1"
            },
            {
              "name":"below",
              "value":"image1"
            }
          ]
        },
        {
          "name": "label1",
          "widget": "UILabel",
          "attr": [
            {
              "name": "size",
              "value": {
                "width": "120dp",
                "height": "30dp"
              }
            },
            {
              "name": "color",
              "value": "#00ff00"
            },           
            {
              "name": "text",
              "value": "Hello World"
            },
            {
              "name": "text_color",
              "value": "#185ca3"
            },
            {
              "name": "margins",
              "value": {
                "left": "0dp",
                "top": "0dp",
                "right": "0dp",
                "bottom": "0dp"
              }
            },
            {
              "name": "align_parent_right",
              "value": true
            },
            {
              "name": "align_parent_top",
              "value": true
            },
            {
              "name":"text_align",
              "value":"center"
            },
            {
              "name": "font_size",
              "value": "18dp"
            }
          ]
        }        
      ]    
  }
}
