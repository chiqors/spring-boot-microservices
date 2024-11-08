## Spring Boot Microservices Application Architecture

![img.png](img.png)

This project is a practice implementation of a simple ordering and product management system using Spring Boot microservices. The goal of this project is to demonstrate the use of microservices architecture, asynchronous communication, fault tolerance, and monitoring in the context of a basic e-commerce application.

## Key Features

- **Ordering Product Services**: The application allows users to browse and order products, with the Order Service managing the order processing and fulfillment workflows.
- **Notification Service**: The Notification Service is responsible for delivering updates and alerts to users, such as order status changes or low inventory notifications.
- **Asynchronous Communication**: The services communicate asynchronously using Kafka, which helps to decouple the services and improve the overall system resilience.
- **Fault Tolerance**: The Resilience4J library is used to implement circuit breakers and other fault tolerance patterns, ensuring that the system can gracefully handle failures and maintain availability.
- **Monitoring and Observability**: The application integrates with various monitoring tools, such as OpenTelemetry, Prometheus, and Grafana, to provide visibility into the health and performance of the microservices.
- **Docker and Kubernetes Configuration**: This project includes the basic configuration files for building Docker images and deploying the application to a Kubernetes cluster.

## Application Architecture

The diagram illustrates the application architecture of this Spring Boot-based microservices system. The key components and their interactions are as follows:

1. **Actor**: The user or external system that interacts with the application.
2. **API Gateway**: The entry point for the application, handling authentication, routing, and load balancing.
3. **Auth Server**: Responsible for user authentication and authorization.
4. **Product Service**: Handles product-related operations, such as creating, updating, and retrieving product information.
5. **Order Service**: Manages the order processing and fulfillment workflows.
6. **Inventory Service**: Tracks and manages the inventory of products.
7. **Notification Service**: Handles the delivery of notifications to users, such as order updates or alerts.
8. **Kafka**: A distributed streaming platform used for asynchronous communication between services.
9. **Resilience4J**: A library that provides fault tolerance and circuit breaker patterns to improve the reliability of the system.
10. **Monitoring Tools**: The diagram includes several monitoring and observability tools, such as OpenTelemetry, Prometheus, and Grafana, which are used to monitor the health and performance of the microservices.

## Technology Stack

- **Spring Boot**: The core framework used to build the microservices.
- **Kafka**: A distributed streaming platform for asynchronous communication between services.
- **Resilience4J**: A library that provides fault tolerance and circuit breaker patterns.
- **OpenTelemetry, Prometheus, Grafana**: Tools used for monitoring and observability.
- **Docker**: Used for building and packaging the microservices into containerized applications.
- **Kubernetes**: The container orchestration platform used for deploying and managing the microservices.