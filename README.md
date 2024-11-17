## Spring Boot Microservices Application Architecture

![img.png](img.png)

This project is a practice implementation of a simple ordering and product management system using Spring Boot microservices. The goal of this project is to demonstrate the use of microservices architecture, asynchronous communication, fault tolerance, and monitoring in the context of a basic e-commerce application.

## Key Features

- **Ordering Product Services**: The application allows users to browse and order products, with the Order Service managing the order processing and fulfillment workflows.
- **Notification Service**: The Notification Service is responsible for delivering updates and alerts to users, such as order status changes or low inventory notifications. It supports sending emails and can be configured with SMTP settings for testing with Mailtrap or a production SMTP setup.
- **Asynchronous Communication**: The services communicate asynchronously using Kafka, which helps to decouple the services and improve the overall system resilience.
- **Fault Tolerance**: The Resilience4J library is used to implement circuit breakers and other fault tolerance patterns, ensuring that the system can gracefully handle failures and maintain availability.
- **API Documentation**: The project uses Springdoc OpenAPI to generate comprehensive API documentation. This allows developers to easily understand and interact with the application's RESTful services through an automatically generated OpenAPI specification, which can be accessed via a user-friendly interface.
- **Authentication and Authorization**: The application uses Keycloak to manage authentication and authorization, providing secure access control across services. Keycloak handles user logins, role-based access, and integrates with existing identity providers.
- **Monitoring and Observability**: The application integrates with various monitoring tools, such as OpenTelemetry, Prometheus, and Grafana, to provide visibility into the health and performance of the microservices.
- **Docker and Kubernetes Configuration**: This project includes the basic configuration files for building Docker images and deploying the application to a Kubernetes cluster. Additionally, a build-images.sh script is provided to streamline the process of building and pushing Docker images using a bash script for easier management.
- **Testing with Testcontainers**: By utilizing the Testcontainers dependency, the application can perform isolated testing of services with their required dependencies. This approach ensures that tests are reliable and can simulate real-world scenarios effectively.

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

## Future Improvement Plan

- Implement client discovery service and load balancing using Netflix Eureka.
- Utilize Helm Charts and Kustomize for deploying multiple Kubernetes environments.
- Implement a config server for managing the microservices environment.
- Implement a BOM (Bill of Materials) for global dependency version management to ensure consistency across microservices.
- Generate a unique correlation ID for each service, containing metadata such as `{service_name, traceId, spanId}`. The `traceId` serves as the correlation ID for tracking requests across services, while the `spanId` is generated upon receiving a request for that specific service. This setup will facilitate distributed tracing, allowing developers to track each request from service A to B until completion, starting from the API gateway.
- Implement Grafana UI integration to enable navigation from Loki to Tempo, allowing developers to view detailed information related to correlation IDs and trace requests across the microservices architecture.
- Implement and update metadata and details for OpenAPI documentation on each service to ensure comprehensive and accurate API specifications.
