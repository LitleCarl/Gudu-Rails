render_json_attrs(json, order_item, [:id, :quantity, :price_snapshot, :order_id])
json.product do | json |
  json.partial! 'products/product', product: order_item.product
end
json.product do | json |
  json.partial! 'products/product', product: order_item.product
end
json.specification do | json |
  json.partial! 'specifications/specification', specification: order_item.specification
end
