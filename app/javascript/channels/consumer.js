// Action Cable provides the framework to deal with WebSockets in Rails.
// You can generate new channels where WebSocket features live using the `bin/rails generate channel` command.
// Клиент соединяется с Сервером с помощью createConsumer(). (consumer.js). Сервер идентифицирует экземпляр этого соединения по current_user

import { createConsumer } from "@rails/actioncable"

export default createConsumer()
