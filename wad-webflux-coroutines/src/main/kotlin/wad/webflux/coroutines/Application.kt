package wad.webflux.coroutines

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Value
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController
import org.springframework.web.reactive.function.client.WebClient
import org.springframework.web.reactive.function.client.awaitBodyOrNull

@SpringBootApplication
class Application

fun main(args: Array<String>) {
    runApplication<Application>(*args)
}

@Configuration
class Config {
    @Bean
    fun webClient(webClientBuilder: WebClient.Builder): WebClient = webClientBuilder.build()
}

@RestController
class PingController {
    @Autowired
    private lateinit var webClient: WebClient

    @Value("\${pong.host:}")
    private lateinit var pongHost: String

    @GetMapping("ping")
    suspend fun ping(): String? = getRawPong()

    @GetMapping("ping/beautified")
    suspend fun pingBeautified(): String? = getBeautifulPong()

    private suspend fun getBeautifulPong(): String? {
        val rawPong = getRawPong()

        return rawPong?.let {
            rawPong.replaceFirstChar { it.uppercase() }
                .plus('!')
        }
    }

    private suspend fun getRawPong(): String? =
        webClient
            .get()
            .uri("$pongHost/pong")
            .retrieve()
            .awaitBodyOrNull()
}

