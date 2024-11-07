package com.chiqors.microservices.order.service;

import com.chiqors.microservices.order.client.InventoryClient;
import com.chiqors.microservices.order.dto.OrderRequest;
import com.chiqors.microservices.order.event.OrderPlacedEvent;
import com.chiqors.microservices.order.model.Order;
import com.chiqors.microservices.order.repository.OrderRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class OrderService {
    private final OrderRepository orderRepository;
    private final InventoryClient inventoryClient;
    private final KafkaTemplate<String, OrderPlacedEvent> kafkaTemplate;

    public void placeOrder(OrderRequest orderRequest) {
        boolean isProductInStock = inventoryClient.isInStock(orderRequest.skuCode(), orderRequest.quantity());

        if (isProductInStock) {
            log.info("Product with SKU code {} is in stock", orderRequest.skuCode());
            Order order = new Order();
            order.setOrderNumber(UUID.randomUUID().toString());
            order.setPrice(orderRequest.price());
            order.setSkuCode(orderRequest.skuCode());
            order.setQuantity(orderRequest.quantity());
            orderRepository.save(order);
            log.info("Order placed: {}", order);

            // Send the message to Kafka Topic
            OrderPlacedEvent orderPlacedEvent = new OrderPlacedEvent();
            orderPlacedEvent.setOrderNumber(order.getOrderNumber());
            orderPlacedEvent.setEmail(orderRequest.userDetails().email() != null ? orderRequest.userDetails().email() : "");
            orderPlacedEvent.setFirstName(orderRequest.userDetails().firstName() != null ? orderRequest.userDetails().firstName() : "");
            orderPlacedEvent.setLastName(orderRequest.userDetails().lastName() != null ? orderRequest.userDetails().lastName() : "");
            log.info("Start - Sending OrderPlacedEvent {} to Kafka topic order-placed", orderPlacedEvent);
            kafkaTemplate.send("order-placed", orderPlacedEvent);
            log.info("End - Sending OrderPlacedEvent {} to Kafka topic order-placed", orderPlacedEvent);
            log.info("---Order placed successfully---");
        } else {
            log.error("Order failed: Out of stock");
            throw new RuntimeException("Product with SKU code " + orderRequest.skuCode() + " is out of stock");
        }
    }
}
