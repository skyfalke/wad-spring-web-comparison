package wad.pong

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController
import reactor.core.publisher.Mono
import java.time.Duration

@SpringBootApplication
class Application

fun main(args: Array<String>) {
    runApplication<Application>(*args)
}

@RestController
class PongController {
    @GetMapping("pong")
    fun pong() = Mono.just("pong")
        .delayElement(Duration.ofSeconds(1))
}
