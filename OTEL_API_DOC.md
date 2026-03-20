# OpenTelemetry Demo API Documentation

Base URL: `https://otel-demo.thebrainsurf.site`

## Overview

The OTEL Demo is a microservices-based e-commerce application that demonstrates distributed tracing, metrics, and logging with OpenTelemetry. Each API call generates telemetry data that can be observed in Prometheus and Grafana.

## API Endpoints

### 🏠 Frontend

```
GET /
```

**Description:** Main e-commerce homepage  
**Response:** HTML page with product listings  
**Traces:** Frontend service interactions

---

### 🛍️ Product Catalog

```
GET /api/products
```

**Description:** Get all available products  
**Response:** JSON array of products  
**Example Response:**

```json
[
  {
    "id": "OLJCESPC7Z",
    "name": "Vintage Typewriter",
    "description": "This typewriter looks good in your living room.",
    "picture": "/static/img/products/typewriter.jpg",
    "priceUsd": {
      "currencyCode": "USD",
      "units": 67,
      "nanos": 990000000
    },
    "categories": ["vintage"]
  }
]
```

```
GET /api/products/{productId}
```

**Description:** Get specific product details  
**Parameters:**

- `productId` (string): Product ID (e.g., "OLJCESPC7Z")

---

### 🛒 Shopping Cart

```
GET /api/cart
```

**Description:** Get current cart contents  
**Headers:**

- `session-id` (optional): User session ID

```
POST /api/cart
```

**Description:** Add item to cart  
**Headers:**

- `session-id` (optional): User session ID  
  **Body:**

```json
{
  "productId": "OLJCESPC7Z",
  "quantity": 1
}
```

```
DELETE /api/cart
```

**Description:** Empty cart  
**Headers:**

- `session-id` (optional): User session ID

---

### 💰 Currency Service

```
GET /api/currency
```

**Description:** Get supported currencies  
**Response:**

```json
{
  "currencyCodes": ["USD", "EUR", "CAD", "JPY", "GBP", "TRY"]
}
```

```
POST /api/currency/convert
```

**Description:** Convert currency  
**Body:**

```json
{
  "from": {
    "currencyCode": "USD",
    "units": 50,
    "nanos": 0
  },
  "toCode": "EUR"
}
```

---

### 🎯 Recommendations

```
GET /api/recommendations
```

**Description:** Get product recommendations  
**Query Parameters:**

- `productIds` (optional): Comma-separated product IDs
- `sessionId` (optional): User session ID

**Example:**

```
GET /api/recommendations?productIds=OLJCESPC7Z,9SIQT8TOJO&sessionId=user123
```

---

### 🚚 Shipping

```
POST /api/shipping/quote
```

**Description:** Get shipping quote  
**Body:**

```json
{
  "address": {
    "streetAddress": "1600 Amphitheatre Parkway",
    "city": "Mountain View",
    "state": "CA",
    "country": "USA",
    "zipCode": "94043"
  },
  "items": [
    {
      "productId": "OLJCESPC7Z",
      "quantity": 1
    }
  ]
}
```

```
POST /api/shipping/ship
```

**Description:** Ship order  
**Body:**

```json
{
  "address": {
    "streetAddress": "1600 Amphitheatre Parkway",
    "city": "Mountain View",
    "state": "CA",
    "country": "USA",
    "zipCode": "94043"
  },
  "items": [
    {
      "productId": "OLJCESPC7Z",
      "quantity": 1
    }
  ]
}
```

---

### 💳 Payment

```
POST /api/payment/charge
```

**Description:** Process payment  
**Body:**

```json
{
  "amount": {
    "currencyCode": "USD",
    "units": 67,
    "nanos": 990000000
  },
  "creditCard": {
    "creditCardNumber": "4432-8015-6152-0454",
    "creditCardCvv": 672,
    "creditCardExpirationYear": 2026,
    "creditCardExpirationMonth": 1
  }
}
```

---

### 🛒 Checkout

```
POST /api/checkout
```

**Description:** Complete order checkout  
**Headers:**

- `session-id` (optional): User session ID
  **Body:**

```json
{
  "userId": "user123",
  "userCurrency": "USD",
  "address": {
    "streetAddress": "1600 Amphitheatre Parkway",
    "city": "Mountain View",
    "state": "CA",
    "country": "USA",
    "zipCode": "94043"
  },
  "email": "user@example.com",
  "creditCard": {
    "creditCardNumber": "4432-8015-6152-0454",
    "creditCardCvv": 672,
    "creditCardExpirationYear": 2026,
    "creditCardExpirationMonth": 1
  }
}
```

---

### 📧 Email Service

```
POST /api/email/send
```

**Description:** Send order confirmation email  
**Body:**

```json
{
  "email": "user@example.com",
  "order": {
    "orderId": "order123",
    "shippingTrackingId": "track123",
    "shippingCost": {
      "currencyCode": "USD",
      "units": 8,
      "nanos": 990000000
    },
    "shippingAddress": {
      "streetAddress": "1600 Amphitheatre Parkway",
      "city": "Mountain View",
      "state": "CA",
      "country": "USA",
      "zipCode": "94043"
    },
    "items": [
      {
        "item": {
          "productId": "OLJCESPC7Z",
          "quantity": 1
        },
        "cost": {
          "currencyCode": "USD",
          "units": 67,
          "nanos": 990000000
        }
      }
    ]
  }
}
```

---

## Testing Examples

### Basic Product Browsing Flow

```bash
# 1. Get all products
curl "https://otel-demo.thebrainsurf.site/api/products"

# 2. Add product to cart
curl -X POST "https://otel-demo.thebrainsurf.site/api/cart" \
  -H "Content-Type: application/json" \
  -H "session-id: test-session-123" \
  -d '{"productId":"OLJCESPC7Z","quantity":1}'

# 3. Get cart contents
curl "https://otel-demo.thebrainsurf.site/api/cart" \
  -H "session-id: test-session-123"

# 4. Get recommendations
curl "https://otel-demo.thebrainsurf.site/api/recommendations?sessionId=test-session-123"
```

### Complete Purchase Flow

```bash
# 1. Add items to cart
curl -X POST "https://otel-demo.thebrainsurf.site/api/cart" \
  -H "Content-Type: application/json" \
  -H "session-id: purchase-test" \
  -d '{"productId":"OLJCESPC7Z","quantity":2}'

# 2. Get shipping quote
curl -X POST "https://otel-demo.thebrainsurf.site/api/shipping/quote" \
  -H "Content-Type: application/json" \
  -d '{
    "address": {
      "streetAddress": "123 Main St",
      "city": "Bangkok",
      "state": "Bangkok",
      "country": "Thailand",
      "zipCode": "10110"
    },
    "items": [{"productId":"OLJCESPC7Z","quantity":2}]
  }'

# 3. Complete checkout
curl -X POST "https://otel-demo.thebrainsurf.site/api/checkout" \
  -H "Content-Type: application/json" \
  -H "session-id: purchase-test" \
  -d '{
    "userId": "test-user-456",
    "userCurrency": "USD",
    "address": {
      "streetAddress": "123 Main St",
      "city": "Bangkok",
      "state": "Bangkok",
      "country": "Thailand",
      "zipCode": "10110"
    },
    "email": "test@example.com",
    "creditCard": {
      "creditCardNumber": "4432-8015-6152-0454",
      "creditCardCvv": 672,
      "creditCardExpirationYear": 2026,
      "creditCardExpirationMonth": 12
    }
  }'
```

---

## Observability

### Metrics Generated

- **HTTP requests:** `http_requests_total`, `http_request_duration_seconds`
- **Business metrics:** Cart operations, checkout success/failure rates
- **Infrastructure:** CPU, memory, network usage per service
- **OTEL Collector:** `otelcol_receiver_accepted_spans_total`

### Traces Generated

Each API call creates distributed traces showing:

- Request flow across microservices
- Service dependencies and call patterns
- Latency breakdown by service
- Error propagation and root cause analysis

### Monitoring URLs

- **Prometheus:** https://prometheus-demo.thebrainsurf.site
- **Grafana:** https://grafana-demo.thebrainsurf.site (admin/admin)
- **Application:** https://otel-demo.thebrainsurf.site

---

## Load Testing Script

```bash
#!/bin/bash
# Generate realistic e-commerce traffic

BASE_URL="https://otel-demo.thebrainsurf.site"
SESSION_ID="load-test-$(date +%s)"

echo "Starting load test with session: $SESSION_ID"

for i in {1..50}; do
    echo "Transaction $i/50..."

    # Browse products
    curl -s "$BASE_URL/api/products" > /dev/null

    # Add random product to cart
    PRODUCTS=("OLJCESPC7Z" "66VCHSJNUP" "1YMWWN1N4O" "L9ECAV7KIM" "2ZYFJ3GM2N")
    PRODUCT=${PRODUCTS[$RANDOM % ${#PRODUCTS[@]}]}

    curl -s -X POST "$BASE_URL/api/cart" \
        -H "Content-Type: application/json" \
        -H "session-id: $SESSION_ID-$i" \
        -d "{\"productId\":\"$PRODUCT\",\"quantity\":$(($RANDOM % 3 + 1))}" > /dev/null

    # Get recommendations
    curl -s "$BASE_URL/api/recommendations?sessionId=$SESSION_ID-$i" > /dev/null

    # Random delay
    sleep $(echo "scale=2; $RANDOM/32767*2" | bc)
done

echo "Load test completed!"
```

---

## Error Scenarios for Testing

### Intentional Failures

```bash
# Invalid product ID (generates 404)
curl "https://otel-demo.thebrainsurf.site/api/products/INVALID_ID"

# Invalid credit card (generates payment failure)
curl -X POST "https://otel-demo.thebrainsurf.site/api/payment/charge" \
  -H "Content-Type: application/json" \
  -d '{
    "amount": {"currencyCode":"USD","units":100,"nanos":0},
    "creditCard": {
      "creditCardNumber": "0000-0000-0000-0000",
      "creditCardCvv": 000,
      "creditCardExpirationYear": 2020,
      "creditCardExpirationMonth": 1
    }
  }'

# Empty cart checkout (generates validation error)
curl -X POST "https://otel-demo.thebrainsurf.site/api/checkout" \
  -H "Content-Type: application/json" \
  -H "session-id: empty-cart-test" \
  -d '{"userId":"test","userCurrency":"USD"}'
```

These error scenarios help test:

- Error rate metrics
- Error trace propagation
- Alert conditions
- Service resilience
