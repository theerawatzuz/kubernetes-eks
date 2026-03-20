#!/bin/bash

echo "🔍 Testing Full Observability Stack (Metrics + Logs + Traces)..."
echo "=============================================================="

# URLs
OTEL_BASE="https://otel-demo.thebrainsurf.site"
GRAFANA_URL="https://grafana-demo.thebrainsurf.site"
PROMETHEUS_URL="https://prometheus-demo.thebrainsurf.site"
LOKI_URL="https://loki-demo.thebrainsurf.site"
TEMPO_URL="https://tempo-demo.thebrainsurf.site"

echo ""
echo "🌐 Testing Service Availability:"
echo "-------------------------------"

services=("OTEL Demo:$OTEL_BASE" "Grafana:$GRAFANA_URL" "Prometheus:$PROMETHEUS_URL" "Loki:$LOKI_URL" "Tempo:$TEMPO_URL")

for service in "${services[@]}"; do
    name=$(echo $service | cut -d: -f1)
    url=$(echo $service | cut -d: -f2-)
    echo -n "$name: "
    curl -s -o /dev/null -w "Status: %{http_code}, Time: %{time_total}s\n" "$url"
done

echo ""
echo "🛒 Generating E-commerce Transactions (with traces)..."
echo "----------------------------------------------------"

# Generate realistic e-commerce transactions
for i in {1..10}; do
    echo "Transaction $i/10..."
    
    # Start transaction - Browse homepage
    curl -s "$OTEL_BASE/" > /dev/null
    
    # Browse products (generates traces)
    curl -s "$OTEL_BASE/api/products" > /dev/null
    
    # Get product details
    PRODUCTS=("OLJCESPC7Z" "66VCHSJNUP" "1YMWWN1N4O" "L9ECAV7KIM" "2ZYFJ3GM2N")
    PRODUCT=${PRODUCTS[$RANDOM % ${#PRODUCTS[@]}]}
    curl -s "$OTEL_BASE/api/products/$PRODUCT" > /dev/null
    
    # Add to cart (generates span)
    curl -s -X POST "$OTEL_BASE/api/cart" \
        -H "Content-Type: application/json" \
        -H "session-id: test-session-$i" \
        -d "{\"productId\":\"$PRODUCT\",\"quantity\":$(($RANDOM % 3 + 1))}" > /dev/null
    
    # Get recommendations (ML service trace)
    curl -s "$OTEL_BASE/api/recommendations?sessionId=test-session-$i" > /dev/null
    
    # Get shipping quote
    curl -s -X POST "$OTEL_BASE/api/shipping/quote" \
        -H "Content-Type: application/json" \
        -d '{
            "address": {
                "streetAddress": "123 Main St",
                "city": "Bangkok",
                "state": "Bangkok", 
                "country": "Thailand",
                "zipCode": "10110"
            },
            "items": [{"productId":"'$PRODUCT'","quantity":1}]
        }' > /dev/null
    
    # Complete checkout (full transaction trace)
    if [ $((i % 3)) -eq 0 ]; then
        # Successful checkout
        curl -s -X POST "$OTEL_BASE/api/checkout" \
            -H "Content-Type: application/json" \
            -H "session-id: test-session-$i" \
            -d '{
                "userId": "test-user-'$i'",
                "userCurrency": "USD",
                "address": {
                    "streetAddress": "123 Main St",
                    "city": "Bangkok",
                    "state": "Bangkok",
                    "country": "Thailand", 
                    "zipCode": "10110"
                },
                "email": "test'$i'@example.com",
                "creditCard": {
                    "creditCardNumber": "4432-8015-6152-0454",
                    "creditCardCvv": 672,
                    "creditCardExpirationYear": 2026,
                    "creditCardExpirationMonth": 12
                }
            }' > /dev/null
    else
        # Failed checkout (for error traces)
        curl -s -X POST "$OTEL_BASE/api/checkout" \
            -H "Content-Type: application/json" \
            -H "session-id: test-session-$i" \
            -d '{"invalid":"data"}' > /dev/null
    fi
    
    # Random delay between transactions
    sleep $(echo "scale=1; $RANDOM/32767*3" | bc)
done

echo ""
echo "✅ Transaction generation complete!"
echo ""
echo "📊 Observability Stack URLs:"
echo "---------------------------"
echo "🎯 Grafana (Main Dashboard):     $GRAFANA_URL"
echo "📈 Prometheus (Metrics):         $PROMETHEUS_URL" 
echo "📝 Loki (Logs):                  $LOKI_URL"
echo "🔍 Tempo (Traces):               $TEMPO_URL"
echo "🛒 OTEL Demo (Application):      $OTEL_BASE"
echo ""
echo "🔍 What to explore in Grafana:"
echo "-----------------------------"
echo "1. 📊 Metrics: Import dashboard or create panels with Prometheus data"
echo "2. 📝 Logs: Use Explore → Loki → Query: {namespace=\"otel-demo\"}"
echo "3. 🔍 Traces: Use Explore → Tempo → Search for recent traces"
echo "4. 🔗 Correlation: Click trace IDs in logs to jump to traces"
echo "5. 📈 Service Map: View service dependencies and performance"
echo ""
echo "🎯 Sample Queries:"
echo "----------------"
echo "Loki (Logs):     {namespace=\"otel-demo\"} |= \"checkout\""
echo "Tempo (Traces):  {service.name=\"frontend\"}"
echo "Prometheus:      rate(http_requests_total[5m])"
echo ""
echo "🚀 Happy Observing! 🔍📊📝"