HOST        = 'http://uat.stockability.com.au/'

### TOKENS ###
tokens_api = 'api/v1/tokens.json'
login = { client: { email: 'daniel.g.myasnikov+telstra@gmail.com', password: 'rus9uGap' } }
token = HTTParty.post(HOST + tokens_api, query: login).parsed_response['token']
auth = { auth: { token: token } }

### PRODUCTS ###
product_api = 'api/v1/products.json'
# please change me :)
FIRSTPRODUCTSKU  = 'MYBEAUTIFULTESTSKU9991'
SECONDPRODUCTSKU = '2SECONDBEAUTIFULTESTSKU998'

create_product = { product: { sku: FIRSTPRODUCTSKU, description: '1st amazing product', batch_tracked: 1 } }
create_product_with_barcodes = { product: { sku: SECONDPRODUCTSKU, description: '2st amazing product', batch_tracked: 1 }, product_barcodes: [{ barcode: 'ZYX999' }, { barcode: 'BLA999' }] }

update_product = { product: { sku: FIRSTPRODUCTSKU, description: '1st amazing product [UPDATED]', batch_tracked: 0 } }
update_product_with_barcodes = { product: { sku: SECONDPRODUCTSKU, description: '2st amazing product [UPDATED]', batch_tracked: 0 }, product_barcodes: [{ barcode: 'ZYX999', quantity: 50 }, { barcode: 'BLA999', quantity: 52}]}

update_product_without_barcodes_with_some_barcodes = update_product = { product: { sku: FIRSTPRODUCTSKU, description: '1st amazing product [UPDATED]', batch_tracked: 0 }, product_barcodes: [{ barcode: '[update_barcode]ZYX999', quantity: 50 }, { barcode: '[update_barcode]BLA999', quantity: 52}] }

HTTParty.get(HOST + product_api)

### PRODUCT BARCODES ###
product_barcodes_api = 'api/v1/product_barcodes.json'

BAR1 = 'MYBEAUTIFULBARCODE'

create_barcode = { product_barcode: { barcode: BAR1, description: '1st amazing product barcode', sku: FIRSTPRODUCTSKU } }
update_barcode = { product_barcode: { description: '1st amazing product [UPDATED]', quantity: 51 } }

update_api = "api/v1/product_barcodes/.json"
HTTParty.post(HOST + product_barcodes_api, query: create_barcode.merge(auth))
HTTParty.put(HOST + update_api, query: update_barcode.merge(auth))
