render_json_attrs(json, payment, [:id, :payment_method, :amount, :transaction_no, :charge_id, :order_id])
json.time_paid payment.time_paid.strftime('%Y年%m月%d日 %H:%M:%S')