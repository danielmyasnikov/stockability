FIRSTPRODUCTSKU = 'MYBEAUTIFULTESTSKU9991'
SECONDPRODUCTSKU = 'SECONDBEAUTIFULTESTSKU998'

create_product = { product: { sku: FIRSTPRODUCTSKU, description: '1st amazing product', batch_tracked: 1 } }
create_product_with_barcodes = { product: { sku: SECONDPRODUCTSKU, description: '2st amazing product', batch_tracked: 1 }, product_barcodes: [{ barcode: 'ZYX999', quantity: 1 }, { barcode: 'BLA999', quantity: 2}]}

update_product = { product: { sku: FIRSTPRODUCTSKU, description: '1st amazing product [UPDATED]', batch_tracked: 0 } }
update_product_with_barcodes = { product: { sku: SECONDPRODUCTSKU, description: '2st amazing product [UPDATED]', batch_tracked: 0 }, product_barcodes: [{ barcode: 'ZYX999', quantity: 50 }, { barcode: 'BLA999', quantity: 52}]}

update_product_without_barcodes_with_some_barcodes = update_product = { product: { sku: FIRSTPRODUCTSKU, description: '1st amazing product [UPDATED]', batch_tracked: 0 }, product_barcodes: [{ barcode: '[update_barcode]ZYX999', quantity: 50 }, { barcode: '[update_barcode]BLA999', quantity: 52}] }
