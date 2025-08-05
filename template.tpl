___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Mapp Intelligence Product Array",
  "description": "Map your product object array to the Mapp Intelligence Smart Pixel data structure",
  "categories": [
    "ANALYTICS",
    "CONVERSIONS",
    "MARKETING"
  ],
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "products",
    "displayName": "Product array",
    "simpleValueType": true,
    "help": "If you have an array of product data objects in your data layer, map the array here.",
    "valueHint": "Array"
  },
  {
    "type": "TEXT",
    "name": "status",
    "displayName": "Product status",
    "simpleValueType": true,
    "help": "Map the status of your product here: \u003cul\u003e\u003cli\u003e \u0027view\u0027: product was seen on a single/detailed product page\u003c/li\u003e\u003cli\u003e\u0027list\u0027: product was seen in a list of products\u003c/li\u003e\u003cli\u003e\u0027addToWishlist\u0027: product was added to wishlist\u003c/li\u003e\u003cli\u003e\u0027deleteFromWishlist\u0027: product was removed from wishlist\u003c/li\u003e\u003cli\u003e\u0027addToCart\u0027: product was added to the shopping cart\u003c/li\u003e\n\u003cli\u003e\u0027deleteFromCart\u0027: product was removed from shopping cart\u003c/li\u003e\u003cli\u003e\u0027checkout\u0027: product was moved to checkout\u003c/li\u003e\u003cli\u003e\u0027confirmation\u0027: product was bought\u003c/li\u003e\u003c/ul\u003e",
    "valueHint": "String"
  },
  {
    "type": "LABEL",
    "name": "remap_help",
    "displayName": "Use the following fields to map your data layer keys with the ones required in the Smart Pixel. For example, if your data layer or product array uses a key called \u0027price\u0027 and you want to use the respective value also in the Smart Pixel, all you need to do is to enter \u0027price\u0027 in the field \u0027Name of cost property\u0027."
  },
  {
    "type": "TEXT",
    "name": "id",
    "displayName": "Name of product ID property",
    "simpleValueType": true,
    "valueHint": "String"
  },
  {
    "type": "TEXT",
    "name": "cost",
    "displayName": "Name of product cost property",
    "simpleValueType": true,
    "valueHint": "String"
  },
  {
    "type": "TEXT",
    "name": "quantity",
    "displayName": "Name of product quantity property",
    "simpleValueType": true,
    "valueHint": "String"
  },
  {
    "type": "TEXT",
    "name": "currency",
    "displayName": "ISO 4217 currency code",
    "simpleValueType": true,
    "valueHint": "String"
  },
  {
    "type": "TEXT",
    "name": "variant",
    "displayName": "Name of product variant property",
    "simpleValueType": true,
    "valueHint": "String"
  },
  {
    "type": "TEXT",
    "name": "soldOut",
    "displayName": "Name of product soldOut property",
    "simpleValueType": true,
    "valueHint": "String"
  },
  {
    "type": "LABEL",
    "name": "parameter_category_help",
    "displayName": "Use the following fields to map your custom e-commerce parameters and categories created in your Mapp Intelligence account to a value in your product object or data layer. For example, if you have a key called \u0027mainCategory\u0027 in the product array of your data layer and you want to  map this to Mapp Intelligence product category ID 1, all you need to do is to add a category mapping below, enter \u00271\u0027 in the left column, and \u0027mainCategory\u0027 in the right column."
  },
  {
    "type": "SIMPLE_TABLE",
    "name": "parameter",
    "displayName": "Ecommerce parameter",
    "simpleTableColumns": [
      {
        "defaultValue": "",
        "displayName": "id",
        "name": "id",
        "type": "TEXT",
        "valueHint": "positive integer",
        "isUnique": true,
        "valueValidators": [
          {
            "type": "POSITIVE_NUMBER"
          }
        ]
      },
      {
        "defaultValue": "",
        "displayName": "Property name",
        "name": "value",
        "type": "TEXT",
        "valueHint": "String"
      }
    ],
    "newRowButtonText": "Map property to ecommerce parameter"
  },
  {
    "type": "SIMPLE_TABLE",
    "name": "category",
    "displayName": "Product categories",
    "simpleTableColumns": [
      {
        "defaultValue": "",
        "displayName": "id",
        "name": "id",
        "type": "TEXT",
        "valueHint": "positive integer",
        "isUnique": true,
        "valueValidators": [
          {
            "type": "POSITIVE_NUMBER"
          }
        ]
      },
      {
        "defaultValue": "",
        "displayName": "Property name",
        "name": "value",
        "type": "TEXT",
        "valueHint": "String"
      }
    ],
    "newRowButtonText": "Map property to product category"
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const makeTableMap_ = require('makeTableMap');
const products_ = data.products ? data.products : [];
if (products_.length > 0) {
    const status_ = data.status ? data.status : 'view';
    const keys_ = [
        'id',
        'cost',
        'quantity',
        'currency',
        'status',
        'soldOut',
        'variant',
        'parameter',
        'category'

    ];

    /**
     * Remaps Object properties to fit Smartpixel product syntax
     * @param {Object} product
     * @returns {Object}
     */
    const makeProduct_ = (product) => {
        const smartPixelProduct = {};
        // try to get the default ones
        keys_.forEach((key) => {
            if (product[key]) {
                smartPixelProduct[key] = product[key];
            }
        });
        // overwrite or add the mapped ones
        keys_.forEach((key) => {
            if (data[key]) {
                const mappedKey = data[key] ? data[key] : key;
                if (key === 'parameter' || key === 'category') {
                    const tableData = makeTableMap_(data[key], 'id', 'value');
                    smartPixelProduct[key] = {};
                    for (let id in tableData) {
                        smartPixelProduct[key][id] = product[tableData[id]];
                    }
                }
                else {
                    smartPixelProduct[key] = product[mappedKey];
                }
            }
        });
        smartPixelProduct.status = smartPixelProduct.status || status_;
        return smartPixelProduct;
    };
    return data.products.map(makeProduct_);
}
return [];


___TESTS___

scenarios: []


___NOTES___

Created on 2/12/2020, 4:43:32 PM


