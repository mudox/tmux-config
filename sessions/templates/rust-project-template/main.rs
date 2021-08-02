use ${crate}::config::Config;
use ${crate}::logging;
use ${crate}::run::run;

fn main() {
    logging::init();
    run(Config::load());
}
