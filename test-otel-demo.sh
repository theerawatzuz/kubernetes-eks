#!/bin/bash

# Simple test for OpenTelemetry Demo Frontend + API
echo "🚀 Testing OTEL Demo (Frontend + API only)..."

FRONTEND_URL="http://otel-demo.thebrainsurf.site"

echo "📱 Testing Frontend..."
curl -s -o /dev/null -w "Status: %{http_code}, Time: %{time_total}s\n" $FRONTEND_URL

echo ""
echo "� Testing API endpoints..."

# Test product API
echo "Testing /api/products..."
curl -s -o /dev/null -w "Status: %{http_code}, Time: %{time_total}s\n" "$FRONTEND_URL/api/products"

# Test cart API
echo "Testing /api/cart..."
curl -s -o /dev/null -w "Status: %{http_code}, Time: %{time_total}s\n" "$FRONTEND_URL/api/cart"

echo ""
echo "� Generating some API traffic..."
for i in {1..5}; do
    echo "Request $i/5..."
    curl -s "$FRONTEND_URL/api/products" > /dev/null
    sleep 1
done

echo ""
echo "✅ Test complete!"
echo "🌐 Frontend URL: $FRONTEND_URL"
echo ""
echo "📋 Next steps:"
echo "1. Check if frontend loads properly"
echo "2. Browse the e-commerce demo"
echo "3. Test API endpoints work"
echo "4. Then we can add Prometheus + Grafana for APM"