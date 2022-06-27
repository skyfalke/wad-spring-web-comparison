package wad.webflux.reactor.coroutines

import kotlinx.coroutines.reactor.awaitSingle
import kotlinx.coroutines.reactor.mono
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Value
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController
import org.springframework.web.reactive.function.client.WebClient
import org.springframework.web.reactive.function.client.bodyToMono
import reactor.core.publisher.Mono

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
    fun ping(): Mono<String> =
        mono {
            getRawPong()
        }

    @GetMapping("ping/beautified")
    fun pingBeautified(): Mono<String> =
        mono {
            getBeautifulPong()
        }

    private suspend fun getBeautifulPong(): String {
        val rawPong = getRawPong()
        return rawPong
            .replaceFirstChar { it.uppercase() }
            .plus('!')
    }

    private suspend fun getRawPong(): String =
        webClient
            .get()
            .uri("$pongHost/pong")
            .retrieve()
            .bodyToMono<String>()
            .awaitSingle()
}