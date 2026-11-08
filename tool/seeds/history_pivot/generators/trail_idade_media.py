# Content source for 05_trail_idade_media.sql (#183)
# Mix: quiz 6, VM 6, timeline 8, who 8, palavra 6, completar 6, batalha 4, conexao 4

TRAIL = {
    "issue": 183,
    "file_num": "05",
    "file_slug": "idade_media",
    "slug_prefix": "im",
    "module": {
        "ordem": 21,
        "titulo": "Idade Média",
        "emoji": "🏰",
        "cor": "#64748B",
        "descricao": "Mil anos de reinos, mosteiros, cidades, ciência islâmica, universidades, peste e guerras: a Idade Média foi um tempo de mudança intensa — não de escuridão.",
    },
    "levels": [
        {"ordem": 1, "titulo": "Nível 1 - Após Roma: reinos, Igreja e Carolíngios"},
        {"ordem": 2, "titulo": "Nível 2 - Senhorios, castelos e cidades"},
        {"ordem": 3, "titulo": "Nível 3 - Islã, Cruzadas e universidades"},
        {"ordem": 4, "titulo": "Nível 4 - Crise e transição para o moderno"},
    ],
    "submodules": [
        {
            "nivel_ordem": 1,
            "ordem": 1,
            "titulo": "Após Roma: reinos bárbaros",
            "preview": "Depois do século V, o Ocidente se dividiu em reinos governados por elites germânicas: visigodos na Hispânia, francos na Gália, ostrogodos na Itália e vândalos no norte da África. 'Bárbaro' era um rótulo romano; na prática, esses reis conviveram com populações romanizadas e aproveitaram cidades, latim e parte do direito romano. Clóvis, rei dos francos, aderiu ao cristianismo niceno e firmou aliança com os bispos da Gália. A transição teve violência e perdas, mas também muita continuidade — não foi um apagão da noite para o dia.",
        },
        {
            "nivel_ordem": 1,
            "ordem": 2,
            "titulo": "Igreja, mosteiros e poder",
            "preview": "Com o enfraquecimento do poder imperial, bispos assumiram assistência, mediação e até governo urbano, e o papado ganhou peso em Roma. Mosteiros, como o de Monte Cassino, ligado a Bento de Núrsia, foram centros de oração, trabalho agrícola, hospedagem e cópia de manuscritos. A Igreja era rica e influente, mas não era um bloco único: papas, bispos, abades e reis disputavam poder o tempo todo. Fé e política andavam juntas.",
        },
        {
            "nivel_ordem": 1,
            "ordem": 3,
            "titulo": "Império Carolíngio",
            "preview": "Os carolíngios assumiram o poder entre os francos com Pepino, o Breve (751). Carlos Magno ampliou o reino e foi coroado imperador pelo papa Leão III no Natal de 800. O governo dependia de condes, de enviados régios (missi dominici) e de laços de fidelidade pessoal — longe de uma burocracia moderna. A reforma das escolas e da escrita, o chamado Renascimento carolíngio, ajudou a preservar textos antigos; em 843, o Tratado de Verdun dividiu o império entre os netos de Carlos Magno.",
        },
        {
            "nivel_ordem": 2,
            "ordem": 4,
            "titulo": "Feudalismo e senhorio",
            "preview": "'Feudalismo' é um conceito historiográfico para descrever relações de fidelidade entre senhores e vassalos ligadas à posse de terras (feudos), sobretudo entre os séculos X e XIII. O senhorio rural, por sua vez, organizava camponeses livres e servos que deviam rendas e trabalho ao senhor. O modelo variou muito entre regiões e épocas: não houve uma pirâmide perfeita e uniforme em toda a Europa, e historiadores ainda debatem o próprio termo.",
        },
        {
            "nivel_ordem": 2,
            "ordem": 5,
            "titulo": "Cavalaria e castelos",
            "preview": "Cavaleiros eram guerreiros de elite a cavalo, cujo ideal combinava prestígio militar, honra e, mais tarde, valores corteses e religiosos. Os primeiros castelos, nos séculos X e XI, muitas vezes eram torres de madeira sobre montes de terra; os de pedra se generalizaram depois. O castelo era residência, fortaleza e centro de poder local — não apenas cenário de torneios. A guerra real foi bem menos romântica do que nos romances de cavalaria.",
        },
        {
            "nivel_ordem": 2,
            "ordem": 6,
            "titulo": "Cidades e guildas",
            "preview": "A partir do século XI, o crescimento da população e do comércio reativou antigas cidades e fez surgir outras. Mercadores e artesãos se organizaram em guildas e corporações de ofício, que regulavam qualidade, preços e aprendizado. Muitas cidades obtiveram cartas de franquia e conselhos próprios, negociando autonomia com senhores e reis. Feiras como as de Champagne e redes como a Liga Hanseática conectaram regiões distantes — a Europa medieval estava longe de ser parada.",
        },
        {
            "nivel_ordem": 3,
            "ordem": 7,
            "titulo": "Mundo islâmico medieval",
            "preview": "Depois das conquistas do século VII, o califado reuniu povos, línguas e religiões muito diversos; a conversão ao islã foi gradual, ao longo de séculos. Sob os abássidas, Bagdá (fundada em 762) tornou-se um grande polo de comércio e saber. Estudiosos traduziram textos gregos, persas e indianos e produziram obras originais em matemática, medicina, astronomia e óptica. Al-Andalus, na Península Ibérica, foi outro centro de cultura que dialogou com o mundo cristão.",
        },
        {
            "nivel_ordem": 3,
            "ordem": 8,
            "titulo": "Cruzadas e encontros",
            "preview": "As Cruzadas foram expedições militares autorizadas pela Igreja, a partir do Concílio de Clermont (1095). A Primeira tomou Jerusalém em 1099 e criou Estados latinos no Levante; Saladino retomou a cidade em 1187. A Quarta Cruzada saqueou Constantinopla em 1204 — cristãos contra cristãos. Além da guerra, houve comércio, diplomacia e trocas de conhecimento, como nas traduções feitas em Toledo e na Sicília.",
        },
        {
            "nivel_ordem": 3,
            "ordem": 9,
            "titulo": "Escolástica e universidades",
            "preview": "As universidades surgiram nos séculos XII e XIII como corporações de mestres e estudantes, em cidades como Bolonha, Paris e Oxford. Estudavam-se artes liberais, direito, medicina e teologia. A escolástica usava a lógica e a disputa organizada para tratar de fé e razão; Tomás de Aquino integrou Aristóteles à teologia cristã. Não era um pensamento parado: aquelas discussões formaram hábitos de argumentação que atravessaram a Idade Moderna.",
        },
        {
            "nivel_ordem": 4,
            "ordem": 10,
            "titulo": "Peste Negra",
            "preview": "A peste, causada pela bactéria Yersinia pestis, chegou à Europa em 1347 por rotas comerciais e matou uma parcela enorme da população até 1351. Cidades portuárias passaram a isolar navios e pessoas, ajudando a consolidar a prática da quarentena. A falta de mão de obra elevou salários em várias regiões e tensionou relações senhoriais. A epidemia também liberou pânico e intolerância: houve massacres de comunidades judaicas em 1348–1349.",
        },
        {
            "nivel_ordem": 4,
            "ordem": 11,
            "titulo": "Guerras e revoltas do fim",
            "preview": "A Guerra dos Cem Anos entre Inglaterra e França (1337–1453) durou 116 anos, com tréguas e fases distintas, e teve Azincourt, Joana d'Arc e uso crescente de artilharia. Revoltas populares, como a Jacquerie (1358) na França e a Revolta dos Camponeses (1381) na Inglaterra, mostraram tensões sociais depois da peste. Na Inglaterra, a Guerra das Duas Rosas terminou em 1485 com a vitória de Henrique Tudor. Esses conflitos ajudaram a fortalecer monarquias que concentravam impostos e exércitos.",
        },
        {
            "nivel_ordem": 4,
            "ordem": 12,
            "titulo": "Transição para o moderno",
            "preview": "Em 1453, os otomanos tomaram Constantinopla; por volta de 1450, Gutenberg aperfeiçoou em Mainz a impressão com tipos móveis metálicos; em 1492, Granada caiu e Colombo cruzou o Atlântico. O Renascimento valorizou o humanismo e a Antiguidade clássica a partir da Itália. A passagem para a Idade Moderna é uma convenção de historiadores, não um corte súbito: muita coisa medieval seguiu viva por séculos.",
        },
    ],
    "items": [],  # filled below
}


def _q(sub, pair, gt, hook, concept, qd, demand="media", short=None):
    return {
        "sub_ordem": sub,
        "pair_ordem": pair,
        "game_type": gt,
        "preview_hook": hook,
        "concept_title": concept,
        "cognitive_demand": demand,
        "short_explanation": short,
        "question_data": qd,
    }


items = []

# Sub 1 — quiz, VM, who, batalha
items.append(_q(1, 1, "quiz-relampago", "Quem governou a Itália a partir de Ravena depois de Odoacro?", "Teodorico e os ostrogodos", {
    "enunciado": "Qual rei ostrogodo governou a Itália a partir de Ravena, depois de eliminar Odoacro, no fim do século V?",
    "alternativas": ["Alarico I", "Teodorico", "Átila", "Clóvis"],
    "correta": 1,
    "explicacao": "Teodorico, rei dos ostrogodos, controlou a Itália a partir de 493 e governou com burocratas romanos e instituições locais preservadas.",
}, "alta"))

items.append(_q(1, 2, "verdade-mito", "Os reinos germânicos acabaram com toda a cultura e a administração romanas.", "Continuidade romana", {
    "texto": "Os reinos germânicos do Ocidente destruíram por completo a administração, o latim e o direito romanos.",
    "veredito": "mito",
    "explicacao": "Houve rupturas, mas os novos reis mantiveram cidades, bispos, latim e legislação romana adaptada, como o Breviário de Alarico (506), dos visigodos.",
}))

items.append(_q(1, 3, "quem-sou-eu", "Quem sou eu?", "Clóvis", {
    "header": "Quem sou eu?",
    "dica_1": "Governei os francos entre o fim do século V e o início do VI.",
    "dica_2": "Venci os visigodos na batalha de Vouillé, em 507.",
    "dica_3": "Aderi ao cristianismo niceno, o que aproximou meu reino dos bispos da Gália.",
    "dica_4": "Sou associado à dinastia merovíngia.",
    "resposta_certa": "Clóvis",
    "sinonimos_aceitos": ["Clovis", "Clóvis I", "Clodovico"],
    "explicacao": "Clóvis consolidou o reino franco e sua aliança com a Igreja nicena foi decisiva para a Gália pós-romana.",
}))

items.append(_q(1, 4, "batalha", "Como foi a relação entre elites germânicas e populações locais?", "Reinos e populações locais", {
    "pergunta": "Qual afirmação é mais precisa sobre os reinos germânicos no Ocidente pós-romano?",
    "opcao_a": "Elites germânicas governaram convivendo com populações romanizadas e instituições romanas adaptadas",
    "opcao_b": "Povos germânicos substituíram toda a população local em poucas décadas",
    "correta": "a",
    "criterio_comparacao": "Natureza dos reinos pós-romanos",
    "explicacao": "Os povos germânicos eram minorias governantes que se misturaram gradualmente às populações locais; não houve substituição demográfica total.",
}))

# Sub 2 — palavra, completar, timeline, quiz
items.append(_q(2, 1, "palavra_misteriosa", "Sala de mosteiro onde monges copiavam manuscritos à mão.", "Scriptorium", {
    "palavra": "Scriptorium",
    "descricao": "Espaço de um mosteiro dedicado à cópia manual de livros e documentos.",
    "dica": "A palavra vem do latim 'scribere', escrever.",
    "explicacao": "Nos scriptoria monásticos copiaram-se textos bíblicos, litúrgicos e também obras da Antiguidade, ajudando a preservá-los.",
}))

items.append(_q(2, 2, "completar_frase", "Bento de Núrsia fundou o mosteiro de [1] e escreveu a [2].", "Monte Cassino e a Regra", {
    "sentenca": "Bento de Núrsia fundou, tradicionalmente por volta de 529, o mosteiro de [1] e escreveu a [2], que organizou a vida monástica no Ocidente.",
    "lacunas": [
        {"ordem": 1, "opcoes": ["Cluny", "Monte Cassino", "Ravena"], "correta": "Monte Cassino"},
        {"ordem": 2, "opcoes": ["Regra", "Bula", "Cruzada"], "correta": "Regra"},
    ],
    "explicacao": "A Regra de São Bento definiu rotina de oração, trabalho e vida comunitária e se tornou referência para muitos mosteiros ocidentais.",
}))

items.append(_q(2, 3, "linha-do-tempo", "Mosteiros beneditinos se espalham pelo Ocidente a partir do século VI.", "Mosteiros como centros", {
    "situacao_inicial": "A partir do século VI, mosteiros que seguem a Regra de São Bento se multiplicam pelo Ocidente latino.",
    "alternativas": [
        "Todos os mosteiros são fechados pelos reis francos",
        "Tornam-se centros de oração, trabalho agrícola, assistência, cópia de manuscritos e ensino",
        "Passam a ser governados por sultões abássidas",
    ],
    "correta": 1,
    "tipo_relacao": "causa_efeito",
    "explicacao": "Os mosteiros combinaram vida religiosa com economia agrária e cultura escrita, e tiveram grande peso social e político.",
}))

items.append(_q(2, 4, "quiz-relampago", "Que papel os bispos costumavam ter em cidades do Ocidente pós-romano?", "Bispos e cidades", {
    "enunciado": "Com o enfraquecimento do poder imperial, que papel os bispos costumavam assumir em muitas cidades do Ocidente?",
    "alternativas": [
        "Apenas funções cerimoniais sem influência social",
        "Liderança religiosa, assistência e, muitas vezes, mediação e governo urbano",
        "Comando exclusivo das legiões romanas",
        "Fiscalização do comércio marítimo bizantino",
    ],
    "correta": 1,
    "explicacao": "Bispos organizaram assistência aos pobres, defenderam cidades e negociaram com reis, tornando-se figuras políticas importantes.",
}, "alta"))

# Sub 3 — conexao, VM, who, timeline
items.append(_q(3, 1, "conexao", "Relacione eventos e significados no mundo carolíngio.", "Mundo carolíngio", {
    "titulo": "Império Carolíngio",
    "subtitulo": "Ligue cada evento ao seu significado.",
    "coluna_esquerda": [
        {"id": "e1", "texto": "Natal de 800"},
        {"id": "e2", "texto": "Renascimento carolíngio"},
        {"id": "e3", "texto": "Tratado de Verdun (843)"},
    ],
    "coluna_direita": [
        {"id": "d1", "texto": "Divisão do império entre os netos de Carlos Magno"},
        {"id": "d2", "texto": "Carlos Magno é coroado imperador pelo papa Leão III"},
        {"id": "d3", "texto": "Reforma de escolas e da escrita, com a minúscula carolina"},
    ],
    "pares": [
        {"esquerda_id": "e1", "direita_id": "d2", "explicacao": "Em Roma, Leão III coroou Carlos Magno imperador no Natal de 800."},
        {"esquerda_id": "e2", "direita_id": "d3", "explicacao": "Escolas palatinas e monásticas e a minúscula carolina ajudaram a copiar e preservar muitos textos."},
        {"esquerda_id": "e3", "direita_id": "d1", "explicacao": "O tratado repartiu o império em reinos ocidental, médio e oriental."},
    ],
}))

items.append(_q(3, 2, "verdade-mito", "Carlos Magno governou com uma burocracia centralizada e moderna.", "Governo carolíngio", {
    "texto": "O Império Carolíngio era governado por uma burocracia estatal centralizada, semelhante à de um Estado moderno.",
    "veredito": "mito",
    "explicacao": "O poder dependia de condes, de enviados régios (missi dominici), de assembleias e de laços de fidelidade pessoal; a administração era limitada e muito dependente do rei.",
}))

items.append(_q(3, 3, "quem-sou-eu", "Quem sou eu?", "Carlos Magno", {
    "header": "Quem sou eu?",
    "dica_1": "Fui rei dos francos e também dos lombardos.",
    "dica_2": "Fui coroado imperador pelo papa Leão III no Natal de 800.",
    "dica_3": "Mantive uma corte em Aachen e atraí letrados como Alcuíno.",
    "dica_4": "Sou filho de Pepino, o Breve.",
    "resposta_certa": "Carlos Magno",
    "sinonimos_aceitos": ["Carlos Magno, rei dos francos", "Charlemagne", "Carlos I", "Carolus Magnus"],
    "explicacao": "Carlos Magno expandiu o reino franco, tornou-se imperador em 800 e patrocinou a reforma cultural carolíngia.",
}))

items.append(_q(3, 4, "linha-do-tempo", "Os filhos de Luís, o Piedoso, disputam a herança carolíngia.", "Tratado de Verdun", {
    "situacao_inicial": "Depois da morte de Luís, o Piedoso, em 840, seus filhos disputam a herança do Império Carolíngio.",
    "alternativas": [
        "Os filhos mantêm o império unido sob um só imperador por mais dois séculos",
        "O papa assume o governo direto de todos os territórios",
        "O Tratado de Verdun (843) divide o império em reinos ocidental, médio e oriental",
    ],
    "correta": 2,
    "tipo_relacao": "sequencia",
    "explicacao": "O Tratado de Verdun repartiu o império entre Carlos, o Calvo, Lotário e Luís, o Germânico, marcando o fim da unidade carolíngia.",
}))

# Sub 4 — quiz, palavra, completar, batalha
items.append(_q(4, 1, "quiz-relampago", "O que era a vassalagem?", "Vassalagem", {
    "enunciado": "Na Europa medieval, a vassalagem era sobretudo uma relação de quê?",
    "alternativas": [
        "Fidelidade e serviço de um vassalo a um senhor, em troca de proteção e, em geral, de um feudo",
        "Propriedade total de uma pessoa sobre outra, como na escravidão romana",
        "Contrato comercial entre mercadores de cidades diferentes",
        "Tributo cobrado pela Igreja a todos os fiéis",
    ],
    "correta": 0,
    "explicacao": "O vassalo jurava fidelidade e prestava serviço (militar, conselho) a um senhor, que oferecia proteção e normalmente uma concessão de terra, o feudo.",
}, "alta"))

items.append(_q(4, 2, "palavra_misteriosa", "Concessão de terra ou direitos em troca de fidelidade e serviço.", "Feudo", {
    "palavra": "Feudo",
    "descricao": "Concessão de terra ou de direitos feita por um senhor a um vassalo em troca de fidelidade e serviço.",
    "dica": "Dá nome ao termo 'feudalismo'.",
    "explicacao": "O feudo ligava terra e fidelidade, mas seus formatos variaram muito entre regiões e épocas.",
}))

items.append(_q(4, 3, "completar_frase", "Os [1] trabalhavam parte do tempo na [2] do senhor.", "Servos e reserva senhorial", {
    "sentenca": "No senhorio rural, os [1] estavam ligados à terra e deviam obrigações ao senhor, incluindo trabalho na [2] senhorial.",
    "lacunas": [
        {"ordem": 1, "opcoes": ["servos", "cavaleiros", "bispos"], "correta": "servos"},
        {"ordem": 2, "opcoes": ["corte", "reserva", "catedral"], "correta": "reserva"},
    ],
    "explicacao": "A reserva senhorial era a parte das terras cultivada diretamente para o senhor, com trabalho (corveia) dos camponeses dependentes.",
}))

items.append(_q(4, 4, "batalha", "O feudalismo foi um sistema único e idêntico em toda a Europa?", "Variação do feudalismo", {
    "pergunta": "Qual afirmação é mais precisa sobre o feudalismo?",
    "opcao_a": "Foi um sistema único e idêntico em toda a Europa durante mil anos",
    "opcao_b": "Variou muito entre regiões e épocas, e historiadores debatem o próprio conceito",
    "correta": "b",
    "criterio_comparacao": "Uniformidade do feudalismo",
    "explicacao": "Relações de vassalagem e senhorio existiram de formas muito diferentes; por isso o termo 'feudalismo' é debatido e usado com cautela.",
}))

# Sub 5 — VM, who, timeline, quiz
items.append(_q(5, 1, "verdade-mito", "Todos os castelos medievais eram grandes fortalezas de pedra desde o início.", "Primeiros castelos", {
    "texto": "Desde o início da era dos castelos (séculos X–XI), todos eram grandes fortalezas de pedra.",
    "veredito": "mito",
    "explicacao": "Muitos dos primeiros castelos eram torres e paliçadas de madeira sobre montes de terra; as grandes construções de pedra se generalizaram depois.",
}))

items.append(_q(5, 2, "quem-sou-eu", "Quem sou eu?", "Guilherme, o Conquistador", {
    "header": "Quem sou eu?",
    "dica_1": "Fui duque da Normandia no século XI.",
    "dica_2": "Venci Haroldo Godwinson na batalha de Hastings, em 1066.",
    "dica_3": "Construí castelos para controlar a Inglaterra conquistada.",
    "dica_4": "Mandei fazer o levantamento de terras conhecido como Domesday Book.",
    "resposta_certa": "Guilherme, o Conquistador",
    "sinonimos_aceitos": ["Guilherme I", "Guilherme da Normandia", "William the Conqueror", "Guilherme o Conquistador"],
    "explicacao": "Guilherme tornou-se rei da Inglaterra após Hastings e reorganizou a elite e o território do reino.",
}))

items.append(_q(5, 3, "linha-do-tempo", "Guilherme da Normandia vence Haroldo em Hastings.", "Após Hastings", {
    "situacao_inicial": "Em 1066, Guilherme da Normandia derrota o rei Haroldo na batalha de Hastings.",
    "alternativas": [
        "A Inglaterra passa a ser governada diretamente pelo papa",
        "Os normandos abandonam a ilha e devolvem o trono aos dinamarqueses",
        "Os normandos constroem castelos e redistribuem terras a uma nova elite, reorganizando o reino",
    ],
    "correta": 2,
    "tipo_relacao": "causa_efeito",
    "explicacao": "A conquista normanda trocou a elite governante inglesa e foi acompanhada por muitos castelos e por um novo arranjo de terras e fidelidades.",
}))

items.append(_q(5, 4, "quiz-relampago", "Qual era a função principal de um castelo medieval?", "Função do castelo", {
    "enunciado": "Qual destas descrições se aproxima mais da função de um castelo medieval?",
    "alternativas": [
        "Mosteiro de clausura para monges copistas",
        "Mercado fixo controlado por guildas",
        "Residência fortificada do senhor e centro de poder militar e administrativo local",
        "Universidade para estudo de direito",
    ],
    "correta": 2,
    "explicacao": "O castelo reunia moradia, defesa, justiça e controle do território; era instrumento de poder do senhor sobre a região.",
}, "alta"))

# Sub 6 — conexao, completar, palavra, timeline
items.append(_q(6, 1, "conexao", "Relacione instituições urbanas e funções.", "Economia urbana medieval", {
    "titulo": "Cidades e guildas",
    "subtitulo": "Ligue cada instituição à sua função.",
    "coluna_esquerda": [
        {"id": "e1", "texto": "Corporações de ofício"},
        {"id": "e2", "texto": "Feiras de Champagne"},
        {"id": "e3", "texto": "Liga Hanseática"},
    ],
    "coluna_direita": [
        {"id": "d1", "texto": "Rede de cidades mercantis do norte da Europa"},
        {"id": "d2", "texto": "Regulavam qualidade, preços e aprendizado de um ofício"},
        {"id": "d3", "texto": "Grandes encontros comerciais entre mercadores de várias regiões"},
    ],
    "pares": [
        {"esquerda_id": "e1", "direita_id": "d2", "explicacao": "As corporações definiam padrões, preços e a formação de aprendizes, oficiais e mestres."},
        {"esquerda_id": "e2", "direita_id": "d3", "explicacao": "Nos séculos XII e XIII, as feiras de Champagne conectaram mercadores do norte e do sul da Europa."},
        {"esquerda_id": "e3", "direita_id": "d1", "explicacao": "A Hansa articulou cidades do Báltico e do mar do Norte para defender interesses comerciais."},
    ],
}))

items.append(_q(6, 2, "completar_frase", "O [1] aprendia com um mestre e podia chegar a [2].", "Aprendiz e mestre", {
    "sentenca": "Nas corporações de ofício, o [1] aprendia o trabalho com um mestre, depois atuava como oficial e podia aspirar ao título de [2].",
    "lacunas": [
        {"ordem": 1, "opcoes": ["aprendiz", "vassalo", "bispo"], "correta": "aprendiz"},
        {"ordem": 2, "opcoes": ["duque", "mestre", "abade"], "correta": "mestre"},
    ],
    "explicacao": "A carreira típica nas corporações ia de aprendiz a oficial e, para alguns, a mestre — com regras e custos que também limitavam o acesso.",
}))

items.append(_q(6, 3, "palavra_misteriosa", "Núcleo urbano fortificado cujos moradores deram origem à palavra 'burguesia'.", "Burgo", {
    "palavra": "Burgo",
    "descricao": "Povoado fortificado ou núcleo urbano medieval, cujos habitantes eram chamados de burgueses.",
    "dica": "Dele vem a palavra 'burguesia'.",
    "explicacao": "Os burgos cresceram com o comércio e o artesanato; seus moradores viviam mais de ofícios e trocas do que do trabalho agrícola.",
}))

items.append(_q(6, 4, "linha-do-tempo", "O comércio cresce na Europa nos séculos XI–XIII.", "Cartas de franquia", {
    "situacao_inicial": "Com o crescimento do comércio e da população entre os séculos XI e XIII, as cidades ganham peso econômico.",
    "alternativas": [
        "Todas as cidades desaparecem porque o comércio é proibido",
        "Os servos são transformados imediatamente em nobres",
        "Muitas cidades obtêm cartas de franquia e conselhos próprios, negociando autonomia com senhores e reis",
    ],
    "correta": 2,
    "tipo_relacao": "causa_efeito",
    "explicacao": "A riqueza urbana permitiu negociar privilégios e formas de autogoverno, em arranjos que variaram de cidade para cidade.",
}))

# Sub 7 — quiz, VM, who, batalha
items.append(_q(7, 1, "quiz-relampago", "Qual cidade foi a capital abássida fundada em 762?", "Bagdá", {
    "enunciado": "Qual cidade foi fundada em 762 pelo califa al-Mansur e se tornou capital do califado abássida?",
    "alternativas": ["Damasco", "Bagdá", "Córdoba", "Cairo"],
    "correta": 1,
    "explicacao": "Bagdá, às margens do rio Tigre, tornou-se um dos maiores centros urbanos, comerciais e intelectuais do mundo medieval.",
}, "alta"))

items.append(_q(7, 2, "verdade-mito", "Depois das conquistas do século VII, todos os povos do califado se converteram ao islã logo em seguida.", "Conversão gradual", {
    "texto": "Logo depois das conquistas do século VII, todas as populações do califado se converteram ao islã.",
    "veredito": "mito",
    "explicacao": "A conversão foi gradual, ao longo de séculos. Cristãos, judeus e outros grupos continuaram numerosos, com estatuto próprio e pagamento de tributos específicos.",
}))

items.append(_q(7, 3, "quem-sou-eu", "Quem sou eu?", "Avicena", {
    "header": "Quem sou eu?",
    "dica_1": "Nasci perto de Bucara, no fim do século X.",
    "dica_2": "Fui médico e filósofo de língua árabe.",
    "dica_3": "Escrevi o Cânon da Medicina, usado por séculos em escolas europeias.",
    "dica_4": "Meu nome foi latinizado na Europa medieval.",
    "resposta_certa": "Avicena",
    "sinonimos_aceitos": ["Ibn Sina", "Abu Ali ibn Sina"],
    "explicacao": "Avicena (Ibn Sina) sintetizou saber médico e filosófico e influenciou universidades islâmicas e europeias.",
}))

items.append(_q(7, 4, "batalha", "Qual afirmação descreve melhor a ciência no mundo islâmico medieval?", "Ciência islâmica", {
    "pergunta": "Qual afirmação é mais precisa sobre a ciência no mundo islâmico medieval?",
    "opcao_a": "Combinou traduções de textos gregos, persas e indianos com contribuições originais, como as de al-Khwarizmi",
    "opcao_b": "Limitou-se a copiar textos europeus sem acrescentar nada de novo",
    "correta": "a",
    "criterio_comparacao": "Papel do saber islâmico medieval",
    "explicacao": "Estudiosos traduziram e discutiram obras de várias tradições e também produziram novidades em álgebra, óptica, astronomia e medicina.",
}))

# Sub 8 — palavra, completar, timeline, conexao
items.append(_q(8, 1, "palavra_misteriosa", "Expedição militar apoiada pela Igreja, com indulgência espiritual, a partir de 1095.", "Cruzada", {
    "palavra": "Cruzada",
    "descricao": "Expedição militar apoiada pela Igreja medieval, associada à promessa de benefícios espirituais aos participantes.",
    "dica": "O nome vem da cruz usada como emblema pelos combatentes.",
    "explicacao": "As cruzadas misturaram motivação religiosa, interesses políticos e econômicos, e tiveram alvos e resultados bem variados.",
}))

items.append(_q(8, 2, "completar_frase", "O papa [1] II convocou a Primeira Cruzada no Concílio de [2].", "Urbano II e Clermont", {
    "sentenca": "A Primeira Cruzada foi convocada pelo papa [1] II, em 1095, no Concílio de [2].",
    "lacunas": [
        {"ordem": 1, "opcoes": ["Urbano", "Gregório", "Leão"], "correta": "Urbano"},
        {"ordem": 2, "opcoes": ["Niceia", "Clermont", "Verdun"], "correta": "Clermont"},
    ],
    "explicacao": "Em Clermont, Urbano II incentivou a expedição que tomaria Jerusalém em 1099.",
}))

items.append(_q(8, 3, "linha-do-tempo", "Os cruzados tomam Jerusalém em 1099.", "Estados cruzados", {
    "situacao_inicial": "Em 1099, os participantes da Primeira Cruzada conquistam Jerusalém.",
    "alternativas": [
        "Jerusalém permanece sob domínio cristão contínuo até o século XX",
        "Os cruzados criam Estados latinos no Levante, como o Reino de Jerusalém",
        "Toda a Europa se converte ao islã",
    ],
    "correta": 1,
    "tipo_relacao": "causa_efeito",
    "explicacao": "A conquista deu origem a Estados latinos no Levante, que perderam território ao longo do tempo; Saladino retomou Jerusalém em 1187.",
}))

items.append(_q(8, 4, "conexao", "Relacione episódios e consequências.", "Cruzadas e encontros", {
    "titulo": "Cruzadas e encontros",
    "subtitulo": "Ligue cada episódio ao seu significado.",
    "coluna_esquerda": [
        {"id": "e1", "texto": "Saladino (1187)"},
        {"id": "e2", "texto": "Quarta Cruzada (1204)"},
        {"id": "e3", "texto": "Toledo (século XII)"},
    ],
    "coluna_direita": [
        {"id": "d1", "texto": "Saque de Constantinopla por cruzados"},
        {"id": "d2", "texto": "Centro de traduções do árabe para o latim"},
        {"id": "d3", "texto": "Retomada de Jerusalém depois da vitória em Hattin"},
    ],
    "pares": [
        {"esquerda_id": "e1", "direita_id": "d3", "explicacao": "Depois de vencer em Hattin, Saladino retomou Jerusalém."},
        {"esquerda_id": "e2", "direita_id": "d1", "explicacao": "A Quarta Cruzada desviou-se e saqueou a capital bizantina, uma cidade cristã."},
        {"esquerda_id": "e3", "direita_id": "d2", "explicacao": "Em Toledo, textos científicos e filosóficos do árabe passaram ao latim e circularam na Europa."},
    ],
}))

# Sub 9 — VM, who, timeline, quiz
items.append(_q(9, 1, "verdade-mito", "As universidades medievais eram instituições estatais modernas.", "Origem das universidades", {
    "texto": "As universidades medievais surgiram como instituições estatais modernas, financiadas e controladas por governos nacionais.",
    "veredito": "mito",
    "explicacao": "Surgiram como corporações (universitates) de mestres e estudantes, com privilégios concedidos por papas, reis ou autoridades locais, em cidades como Bolonha, Paris e Oxford.",
}))

items.append(_q(9, 2, "quem-sou-eu", "Quem sou eu?", "Tomás de Aquino", {
    "header": "Quem sou eu?",
    "dica_1": "Fui frade dominicano no século XIII.",
    "dica_2": "Ensinei em Paris e escrevi a Suma Teológica.",
    "dica_3": "Procurei conciliar o pensamento de Aristóteles com a teologia cristã.",
    "dica_4": "Sou um dos nomes centrais da escolástica.",
    "resposta_certa": "Tomás de Aquino",
    "sinonimos_aceitos": ["Santo Tomás de Aquino", "Tomas de Aquino", "São Tomás de Aquino"],
    "explicacao": "Tomás de Aquino sistematizou a relação entre fé e razão e influenciou a teologia e a filosofia ocidentais por séculos.",
}))

items.append(_q(9, 3, "linha-do-tempo", "Textos de Aristóteles chegam às escolas cristãs no século XIII.", "Aristóteles na escolástica", {
    "situacao_inicial": "No século XIII, obras de Aristóteles, traduzidas do árabe e do grego, circulam nas escolas e universidades cristãs.",
    "alternativas": [
        "A Igreja destrói todas as universidades",
        "Aristóteles é esquecido na Europa até o século XX",
        "Mestres como Tomás de Aquino buscam conciliar a razão aristotélica com a teologia cristã",
    ],
    "correta": 2,
    "tipo_relacao": "causa_efeito",
    "explicacao": "A recepção de Aristóteles provocou debates intensos e gerou sínteses importantes, como a de Tomás de Aquino.",
}))

items.append(_q(9, 4, "quiz-relampago", "Como funcionava o método escolástico?", "Método escolástico", {
    "enunciado": "Qual destas descrições se aproxima mais do método escolástico de ensino e debate?",
    "alternativas": [
        "Memorização sem discussão de qualquer questão",
        "Experimentos de laboratório com instrumentos modernos",
        "Debate organizado de uma questão, com objeções, respostas e uso da lógica",
        "Leitura exclusiva de textos literários em língua vulgar",
    ],
    "correta": 2,
    "explicacao": "A escolástica estruturava questões em argumentos a favor e contra, resolvidos por distinções lógicas e referência a autoridades.",
}, "alta"))

# Sub 10 — completar, palavra, who, batalha
items.append(_q(10, 1, "completar_frase", "A Peste Negra chegou à Europa em [1], causada pela bactéria [2].", "1347 e Yersinia pestis", {
    "sentenca": "A Peste Negra chegou à Europa em [1], causada pela bactéria [2].",
    "lacunas": [
        {"ordem": 1, "opcoes": ["1347", "1066", "1492"], "correta": "1347"},
        {"ordem": 2, "opcoes": ["Vibrio cholerae", "Yersinia pestis", "vírus da varíola"], "correta": "Yersinia pestis"},
    ],
    "explicacao": "A peste entrou pela rota comercial marítima em 1347; estudos com DNA antigo identificaram Yersinia pestis como agente.",
}))

items.append(_q(10, 2, "palavra_misteriosa", "Isolamento de pessoas ou navios para evitar contágio, originalmente de 40 dias.", "Quarentena", {
    "palavra": "Quarentena",
    "descricao": "Período de isolamento de pessoas ou navios para conter o contágio, ligado originalmente à ideia de quarenta dias.",
    "dica": "Vem do italiano 'quaranta giorni', quarenta dias.",
    "explicacao": "Cidades portuárias como Ragusa e Veneza adotaram isolamentos de navios e consolidaram a prática da quarentena depois da Peste Negra.",
}))

items.append(_q(10, 3, "quem-sou-eu", "Quem sou eu?", "Giovanni Boccaccio", {
    "header": "Quem sou eu?",
    "dica_1": "Fui escritor italiano do século XIV.",
    "dica_2": "Descrevi a peste em Florença, em 1348, como cenário de uma obra em prosa.",
    "dica_3": "Dez jovens se refugiam no campo e contam cem histórias.",
    "dica_4": "Fui amigo de Petrarca.",
    "resposta_certa": "Giovanni Boccaccio",
    "sinonimos_aceitos": ["Boccaccio", "Boccácio", "Giovanni Boccácio"],
    "explicacao": "O Decamerão, de Boccaccio, é um dos testemunhos literários mais famosos sobre a peste de 1348 em Florença.",
}))

items.append(_q(10, 4, "batalha", "Quais foram os efeitos da Peste Negra?", "Efeitos da Peste Negra", {
    "pergunta": "Qual afirmação é mais precisa sobre os efeitos da Peste Negra (1347–1351)?",
    "opcao_a": "Atingiu só a Europa e teve efeito econômico insignificante",
    "opcao_b": "Reduziu drasticamente a população, escasseou mão de obra e alterou salários e relações de trabalho em várias regiões",
    "correta": "b",
    "criterio_comparacao": "Impacto social e econômico da peste",
    "explicacao": "A epidemia também atingiu a Ásia e o norte da África; na Europa, a mortalidade enorme mudou a oferta de trabalho e tensionou relações senhoriais.",
}))

# Sub 11 — VM, timeline, conexao, who
items.append(_q(11, 1, "verdade-mito", "A Guerra dos Cem Anos durou exatamente cem anos, sem pausas.", "Guerra dos Cem Anos", {
    "texto": "A Guerra dos Cem Anos foi um conflito contínuo de exatamente cem anos entre Inglaterra e França.",
    "veredito": "mito",
    "explicacao": "O nome é uma convenção posterior: o conflito foi de 1337 a 1453 (116 anos), com tréguas, fases distintas e períodos de paz.",
}))

items.append(_q(11, 2, "linha-do-tempo", "Camponeses ingleses marcham sobre Londres em 1381.", "Revolta de 1381", {
    "situacao_inicial": "Em 1381, camponeses e artesãos ingleses, irritados com impostos de capitação e restrições ao trabalho, marcham sobre Londres.",
    "alternativas": [
        "O rei Ricardo II abdica e instala uma república camponesa",
        "A revolta é derrotada e as concessões do rei são revogadas, mas expõe as tensões sociais do pós-peste",
        "Todos os impostos são abolidos em toda a Europa",
    ],
    "correta": 1,
    "tipo_relacao": "sequencia",
    "explicacao": "Líderes como Wat Tyler foram mortos ou presos e o rei revogou promessas, mas a revolta mostrou o descontentamento depois da Peste Negra.",
}))

items.append(_q(11, 3, "conexao", "Relacione batalhas e consequências.", "Guerras do fim da Idade Média", {
    "titulo": "Guerras e revoltas do fim",
    "subtitulo": "Ligue cada batalha ao seu desfecho.",
    "coluna_esquerda": [
        {"id": "e1", "texto": "Azincourt (1415)"},
        {"id": "e2", "texto": "Castillon (1453)"},
        {"id": "e3", "texto": "Bosworth (1485)"},
    ],
    "coluna_direita": [
        {"id": "d1", "texto": "Vitória francesa com forte uso de artilharia, no fim da Guerra dos Cem Anos"},
        {"id": "d2", "texto": "Henrique Tudor derrota Ricardo III e inicia a dinastia Tudor"},
        {"id": "d3", "texto": "Vitória inglesa de Henrique V, com destaque para os arqueiros de arco longo"},
    ],
    "pares": [
        {"esquerda_id": "e1", "direita_id": "d3", "explicacao": "Em Azincourt, os ingleses derrotaram um exército francês maior."},
        {"esquerda_id": "e2", "direita_id": "d1", "explicacao": "Castillon é considerada a batalha final da Guerra dos Cem Anos, com peso da artilharia francesa."},
        {"esquerda_id": "e3", "direita_id": "d2", "explicacao": "Bosworth encerrou a Guerra das Duas Rosas e levou os Tudor ao trono."},
    ],
}))

items.append(_q(11, 4, "quem-sou-eu", "Quem sou eu?", "Joana d'Arc", {
    "header": "Quem sou eu?",
    "dica_1": "Nasci em Domrémy, no nordeste da França.",
    "dica_2": "Disse ter recebido vozes que me pediram para apoiar o delfim Carlos.",
    "dica_3": "Participei da libertação de Orléans, em 1429.",
    "dica_4": "Fui julgada por um tribunal eclesiástico e queimada em Ruão, em 1431.",
    "resposta_certa": "Joana d'Arc",
    "sinonimos_aceitos": ["Joana D'Arc", "Jeanne d'Arc", "Joana d Arc", "A Donzela de Orléans"],
    "explicacao": "Joana d'Arc tornou-se símbolo da resistência francesa na Guerra dos Cem Anos; foi reabilitada pela Igreja décadas depois e canonizada em 1920.",
}))

# Sub 12 — completar, palavra, timeline, who
items.append(_q(12, 1, "completar_frase", "Em 1453, o sultão [1] conquistou [2].", "1453 e Constantinopla", {
    "sentenca": "Em 1453, o sultão otomano [1] conquistou [2], pondo fim ao Império Bizantino.",
    "lacunas": [
        {"ordem": 1, "opcoes": ["Mehmed II", "Saladino", "Solimão"], "correta": "Mehmed II"},
        {"ordem": 2, "opcoes": ["Roma", "Constantinopla", "Bagdá"], "correta": "Constantinopla"},
    ],
    "explicacao": "A queda de Constantinopla encerrou o Império Bizantino e é uma das datas usadas para marcar a transição à Idade Moderna.",
}))

items.append(_q(12, 2, "palavra_misteriosa", "Movimento cultural dos séculos XIV–XVI que valorizou o humanismo e a Antiguidade clássica.", "Renascimento", {
    "palavra": "Renascimento",
    "descricao": "Movimento cultural e artístico, iniciado na Itália, que valorizou o humanismo e a retomada de modelos da Antiguidade clássica.",
    "dica": "Ficou associado a nomes como Petrarca, Leonardo da Vinci e Michelangelo.",
    "explicacao": "O Renascimento não rompeu de modo absoluto com a Idade Média: foi construído sobre redes de universidades, cidades e manuscritos medievais.",
}))

items.append(_q(12, 3, "linha-do-tempo", "Granada cai em 1492.", "1492", {
    "situacao_inicial": "Em 1492, Castela e Aragão conquistam Granada, último reino muçulmano da Península Ibérica.",
    "alternativas": [
        "Os reis católicos renunciam ao mar e fecham os portos",
        "O papa dissolve Castela e Aragão",
        "Os mesmos soberanos apoiam a viagem de Colombo, que chega ao Caribe e amplia a expansão atlântica europeia",
    ],
    "correta": 2,
    "tipo_relacao": "sequencia",
    "explicacao": "No mesmo ano, Colombo atravessou o Atlântico com apoio de Castela, abrindo uma nova fase de contatos e conquistas.",
}))

items.append(_q(12, 4, "quem-sou-eu", "Quem sou eu?", "Johannes Gutenberg", {
    "header": "Quem sou eu?",
    "dica_1": "Fui ourives alemão, de Mainz.",
    "dica_2": "Por volta de 1450, aperfeiçoei na Europa um sistema de impressão com tipos móveis metálicos.",
    "dica_3": "Uma Bíblia impressa por volta de 1455 leva meu nome.",
    "resposta_certa": "Johannes Gutenberg",
    "sinonimos_aceitos": ["Gutenberg", "Johann Gutenberg", "Johannes Gensfleisch"],
    "explicacao": "A impressão com tipos móveis já existia na Ásia, mas o sistema de Gutenberg barateou livros na Europa e acelerou a circulação de ideias.",
}))

TRAIL["items"] = items
