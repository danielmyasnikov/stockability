HOST        = 'http://uat.stockability.com.au/'
LOCATION_CODE = 'NEWLOC123'
### TOKENS ###
since = { since: '2015-09-11' }
tokens_api = 'api/v1/tokens.json'
update_api = "api/v1/products/#{id}.json"
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

HTTParty.get(HOST + product_api,  query: auth)
HTTParty.get(HOST + product_api,  query: auth.merge(since))
HTTParty.post(HOST + product_api, query: create_product.merge(auth))
HTTParty.post(HOST + product_api, query: create_product_with_barcodes.merge(auth))

update_product_api = "api/v1/products/#{id}.json"
HTTParty.get(HOST + update_product_api,  query: auth.merge(update_product))
HTTParty.get(HOST + update_product_api,  query: auth.merge(update_product_with_barcodes))
HTTParty.get(HOST + update_product_api,  query: auth.merge(update_product_without_barcodes_with_some_barcodes))

### PRODUCT BARCODES ###
product_barcodes_api = 'api/v1/product_barcodes.json'

BAR1 = 'MYBEAUTIFULBARCODE'

create_barcode = { product_barcode: { barcode: BAR1, description: '1st amazing product barcode', sku: FIRSTPRODUCTSKU } }
update_barcode = { product_barcode: { description: '1st amazing product [UPDATED]', quantity: 51 } }

update_api = "api/v1/product_barcodes/.json"
HTTParty.post(HOST + product_barcodes_api, query: create_barcode.merge(auth))
HTTParty.put(HOST + update_api, query: update_barcode.merge(auth))

### PRODUCT BARCODES ###
product_barcodes_api = 'api/v1/product_barcodes.json'

BAR1 = 'MYBEAUTIFULBARCODE'

create_barcode = { product_barcode: { barcode: BAR1, description: '1st amazing product barcode', sku: FIRSTPRODUCTSKU } }
update_barcode = { product_barcode: { description: '1st amazing product [UPDATED]', quantity: 51 } }

update_api = "api/v1/product_barcodes/#{id}.json"
HTTParty.post(HOST + product_barcodes_api, query: create_barcode.merge(auth))
HTTParty.put(HOST + update_api, query: update_barcode.merge(auth))

### STOCK LEVELS ###
stock_levels_api = 'api/v1/stock_levels.json'
HTTParty.get(HOST + stock_levels_api, query: auth)
HTTParty.get(HOST + stock_levels_api, query: auth.merge(since))

invalid_barcode= { stock_level: { bin_code: 'BIN001', batch_code: 'BATCH01' } }
create_barcode = { stock_level: { bin_code: 'BIN001', sku: FIRSTPRODUCTSKU, batch_code: 'BATCH01', location_code: LOCATION_CODE } }
HTTParty.post(HOST + stock_levels_api, query: invalid_barcode.merge(auth))
HTTParty.post(HOST + stock_levels_api, query: create_barcode.merge(auth))

update_stock_levels_api = 'api/v1/stock_levels/32.json'
update_stock_levels     = { stock_level: { bin_code: 'BIN002', batch_code: 'BATCH05' } }
HTTParty.put(HOST + update_stock_levels_api, query: update_stock_levels.merge(auth))

### TOUR ###
tours_api = 'api/v1/tours.json'
HTTParty.get(HOST + tours_api, query: auth)
HTTParty.get(HOST + tours_api, query: auth.merge(since))

create_tour = { tour: { name: 'MYAWESOMETOUR', active: true, started: '2015-01-01'} }
HTTParty.post(HOST + tours_api, query: create_tour.merge(auth))

update_tour_api = "api/v1/tours/#{id}.json"
update_tour = { tour: { name: 'MYAWESOMETOUR', active: false, completed: '2015-01-02'} }
HTTParty.put(HOST + update_tour_api, query: update_tour.merge(auth))

### TOUR ENTRIES ###
tour_entries_api = 'api/v1/tour_entries.json'
HTTParty.get(HOST + tour_entries_api, query: auth)
HTTParty.get(HOST + tour_entries_api, query: auth.merge(since))

create_tour_entry = { tour_entry: { tour_id: id, sku: FIRSTPRODUCTSKU, batch_code: 'BATCH06', quantity: 55, location_code: LOCATION_CODE, bin_code: 'BIN002', barcode: 'BAR001' } }
resp = HTTParty.post(HOST + tour_entries_api, query: create_tour_entry.merge(auth))
id = resp.parsed_response['id']

update_tour_entry_api = "api/v1/tour_entries/#{id}.json"
update_tour_entry = { tour_entry: { tour_id: id, sku: FIRSTPRODUCTSKU, batch_code: 'BATCH06', quantity: 56, location_code: LOCATION_CODE, bin_code: 'BIN002', barcode: 'BAR001' } }
HTTParty.put(HOST + update_tour_api, query: update_tour_entry.merge(auth))
