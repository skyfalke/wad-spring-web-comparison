package wad.mvc

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Value
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication
import org.springframework.boot.web.client.RestTemplateBuilder
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController
import org.springframework.web.client.RestTemplate

@SpringBootApplication
class Application

fun main(args: Array<String>) {
    runApplication<Application>(*args)
}

@Configuration
class Config {
    @Bean
    fun restTemplate(restTemplateBuilder: RestTemplateBuilder): RestTemplate = restTemplateBuilder.build()
}

@RestController
class PingController {

    @Autowired
    private lateinit var restTemplate: RestTemplate

    @Value("\${pong.host:}")
    private lateinit var pongHost: String

    @GetMapping("ping")
    fun ping(): String? = restTemplate
        .getForEntity("$pongHost/pong", String::class.java)
        .body

    @GetMapping("ping/beautified")
    fun pingBeautified(): String? {
        val rawPong: String? = restTemplate
            .getForEntity("$pongHost/pong", String::class.java)
            .body

        return rawPong?.let {
            rawPong
                .replaceFirstChar { it.uppercase() }
                .plus('!')
        }
    }
}