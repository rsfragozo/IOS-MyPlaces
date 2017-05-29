public enum TipoLocal {
    case trabalho
    case lazer
    case residencia
    case outro
    
    static func array() -> [TipoLocal] {
        return [TipoLocal.trabalho, TipoLocal.lazer,
            TipoLocal.residencia, TipoLocal.outro];
    }
}
