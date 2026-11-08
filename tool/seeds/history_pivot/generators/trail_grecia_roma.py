# Content source for 04_trail_grecia_roma.sql (#182)
# Mix: quiz 6, VM 6, timeline 8, who 8, palavra 6, completar 6, batalha 4, conexao 4

TRAIL = {
    "issue": 182,
    "file_num": "04",
    "file_slug": "grecia_roma",
    "slug_prefix": "gr",
    "module": {
        "ordem": 20,
        "titulo": "Grécia e Roma Antigas",
        "emoji": "🏺",
        "cor": "#CA8A04",
        "descricao": "Da pólis grega ao Império Romano: cidadania, expansão, crise e o legado que ainda organiza o Ocidente.",
    },
    "levels": [
        {"ordem": 1, "titulo": "Nível 1 - Pólis e o mundo grego"},
        {"ordem": 2, "titulo": "Nível 2 - Roma republicana"},
        {"ordem": 3, "titulo": "Nível 3 - Império e transformação"},
        {"ordem": 4, "titulo": "Nível 4 - Queda, Bizâncio e legado"},
    ],
    "submodules": [
        {
            "nivel_ordem": 1,
            "ordem": 1,
            "titulo": "Pólis e cidadania em Atenas",
            "preview": "A democracia ateniense do século V a.C. era direta para cidadãos homens adultos — e excluía mulheres, estrangeiros e escravizados, a maior parte da população. O ágora concentrava política e comércio; o ostracismo afastava líderes temidos sem julgamento criminal. Cleistenes reorganizou as tribos para enfraquecer clãs aristocráticos, e Péricles ligou a cidadania ao serviço público remunerado.",
        },
        {
            "nivel_ordem": 1,
            "ordem": 2,
            "titulo": "Esparta e a sociedade militar",
            "preview": "Esparta era uma oligarquia dual com dois reis, um conselho de anciãos (gerúsia) e a assembleia dos espartiatas. A agogê treinava meninos para a guerra; os hilotas, população submetida da Messênia, sustentavam a elite com trabalho agrícola sob vigilância constante. Termópilas virou mito de sacrifício, mas a força espartana também dependia de aliados e de um sistema social rígido que temia reformas.",
        },
        {
            "nivel_ordem": 1,
            "ordem": 3,
            "titulo": "De Maratona a Alexandre",
            "preview": "As Guerras Médicas (início do século V a.C.) uniram pólis rivais contra o Império Persa: Maratona, Salamina e Plateia entraram na memória grega como vitórias da liberdade — com muita propaganda. Depois, a Guerra do Peloponeso esgotou Atenas e Esparta. No século IV, a Macedônia de Filipe II e Alexandre impôs hegemonia e espalhou o grego helenístico até o Indo.",
        },
        {
            "nivel_ordem": 2,
            "ordem": 4,
            "titulo": "República romana e o Senado",
            "preview": "Após a expulsão dos reis etruscos (tradição: 509 a.C.), Roma organizou uma República com cônsules anuais, magistraturas e um Senado de aristocratas. O conflito patrícios-plebeus produziu tribunos e o acesso gradual às magistraturas. As Doze Tábuas fixaram direito escrito; a expansão itálica criou uma rede de aliados com status jurídicos diferentes — não um Estado nacional moderno.",
        },
        {
            "nivel_ordem": 2,
            "ordem": 5,
            "titulo": "Escravidão, cidadania e expansão",
            "preview": "A conquista do Mediterrâneo trouxe riqueza, escravizados e crises sociais. Cidadania romana era privilégio jurídico progressivamente estendido; socii italianos pediram direitos na Guerra Social (91–88 a.C.). Latifúndios com trabalho escravo pressionaram pequenos camponeses-soldados. Os Gracos tentaram reformas agrárias e morreram na violência política que antecipou o fim da República.",
        },
        {
            "nivel_ordem": 2,
            "ordem": 6,
            "titulo": "César, Augusto e o Principado",
            "preview": "Guerras civis do século I a.C. destruíram o equilíbrio republicano: Mário e Sila, o Primeiro Triunvirato, César ditador vitalício assassinado em 44 a.C., depois Otaviano vence Ácio (31 a.C.). Como Augusto, mantém fachada republicana — Senado, magistraturas — mas concentra o poder real no Principado. A 'restauração da República' foi a fundação do Império.",
        },
        {
            "nivel_ordem": 3,
            "ordem": 7,
            "titulo": "Pax Romana e a vida urbana",
            "preview": "Nos dois primeiros séculos d.C., o Império viveu relativa estabilidade nas fronteiras internas do Mediterrâneo: estradas, direito, cidades com fóruns, termas e aquedutos. A paz era romana e desigual — legiões nas fronteiras, escravidão, e revoltas como a judaica. Cidadania se expandiu até a Constitutio Antoniniana (212), que estendeu o status a homens livres do Império, sobretudo por razões fiscais.",
        },
        {
            "nivel_ordem": 3,
            "ordem": 8,
            "titulo": "Cristianismo no Império",
            "preview": "O cristianismo nasceu no judaísmo do século I, sob domínio romano. Perseguições foram intermitentes, não constantes. Constantino legalizou o culto (Editais de 313) e convocou Niceia (325); Teodósio tornou o cristianismo niceno religião oficial no fim do século IV. A Igreja herdou redes urbanas do Império e se tornou instituição política decisiva na Antiguidade Tardia.",
        },
        {
            "nivel_ordem": 3,
            "ordem": 9,
            "titulo": "Crise do século III",
            "preview": "Entre 235 e 284, Roma viveu a Anarquia Militar: dezenas de imperadores, invasões, peste e inflação. O Império quase se fragmentou (Império das Gálias, Palmira). Diocleciano reorganizou a Tetrarquia, reforçou impostos e a burocracia. A crise mostrou que o Principado augustano já não sustentava um Império sob pressão externa e interna simultâneas.",
        },
        {
            "nivel_ordem": 4,
            "ordem": 10,
            "titulo": "Queda no Ocidente",
            "preview": "Em 476, Odoacro depôs Rômulo Augústulo em Ravena — marco convencional do fim do Império no Ocidente, não o 'apagão' da civilização. Muito antes, saques (Alarico em 410), perda fiscal e o uso crescente de chefes germânicos no exército já tinham transformado o poder. Reinos romano-germânicos preservaram cidades, latim e instituições locais em graus variados.",
        },
        {
            "nivel_ordem": 4,
            "ordem": 11,
            "titulo": "Bizâncio e a continuidade",
            "preview": "O Império Romano do Oriente — que chamamos Bizâncio — sobreviveu até 1453. Justiniano (século VI) reconquistou partes do Ocidente e codificou o direito (Corpus Juris Civilis). Grego tornou-se língua administrativa; Constantinopla era a maior cidade cristã da Idade Média inicial. Falar em 'queda de Roma' em 476 apaga mil anos de Roma oriental.",
        },
        {
            "nivel_ordem": 4,
            "ordem": 12,
            "titulo": "Legado: direito, língua e política",
            "preview": "Do direito romano às línguas românicas, do calendário juliano ao imaginário republicano e imperial, Grécia e Roma moldaram categorias políticas do Ocidente. Filosofia grega e retórica alimentaram escolas; o latim foi língua culta por séculos. Esse legado foi seletivo: escravidão, exclusão de mulheres e imperialismo também fazem parte da herança, não só colunas e discursos sobre liberdade.",
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
items.append(_q(1, 1, "quiz-relampago", "Quem podia votar na democracia ateniense clássica?", "Cidadania ateniense", {
    "enunciado": "Na democracia ateniense do século V a.C., quem em geral podia participar da Eclésia (assembleia)?",
    "alternativas": [
        "Homens adultos considerados cidadãos",
        "Todos os moradores adultos de Atenas",
        "Apenas os membros do Areópago",
        "Mulheres e homens cidadãos em igualdade",
    ],
    "correta": 0,
    "explicacao": "A cidadania política era restrita a homens adultos filhos de pais cidadãos (após Péricles, com regras ainda mais rígidas). Mulheres, metecos e escravizados ficavam de fora.",
}, "alta"))

items.append(_q(1, 2, "verdade-mito", "Atenas inventou a democracia moderna com voto universal.", "Mito da democracia universal", {
    "texto": "A democracia ateniense clássica funcionava como a democracia moderna: com voto universal de adultos.",
    "veredito": "mito",
    "explicacao": "Era democracia direta para um minoria cidadã masculina. Não havia sufrágio universal nem representação parlamentar no sentido moderno.",
}))

items.append(_q(1, 3, "quem-sou-eu", "Quem sou eu?", "Cleístenes", {
    "header": "Quem sou eu?",
    "dica_1": "Reorganizei Atenas em tribos territoriais para enfraquecer os clãs aristocráticos.",
    "dica_2": "Minhas reformas, no final do século VI a.C., abriram caminho à democracia clássica.",
    "dica_3": "Também associo meu nome à prática do ostracismo.",
    "dica_4": "Não sou Sólon — venho depois dele.",
    "resposta_certa": "Cleístenes",
    "sinonimos_aceitos": ["Clistenes", "Cleistenes"],
    "explicacao": "Cleístenes reformou a organização cívica ateniense e é visto como um dos arquitetos da democracia clássica.",
}))

items.append(_q(1, 4, "batalha", "O que melhor descreve o ostracismo ateniense?", "Ostracismo", {
    "pergunta": "O ostracismo ateniense servia principalmente para quê?",
    "opcao_a": "Afastar por dez anos um cidadão visto como ameaça política",
    "opcao_b": "Executar sem julgamento líderes acusados de corrupção",
    "correta": "a",
    "criterio_comparacao": "Função política do ostracismo",
    "explicacao": "O ostracismo era um exílio preventivo por cerca de dez anos, não uma pena capital. Visava reduzir o risco de tirania ou de líderes excessivamente populares.",
}))

# Sub 2 — palavra, completar, timeline, quiz
items.append(_q(2, 1, "palavra_misteriosa", "Sistema de educação militar obrigatória dos meninos espartanos.", "Agogê", {
    "palavra": "Agogê",
    "descricao": "Sistema de educação e treinamento militar pelo qual passavam os meninos espartanos.",
    "dica": "Começava na infância e moldava o espartiata para a vida em quartel e combate.",
    "explicacao": "A agogê era o eixo da socialização militar espartana e separava os espartiatas do restante da população.",
}))

items.append(_q(2, 2, "completar_frase", "Em Esparta, a elite cidadã dependia do trabalho dos [1], enquanto dois [2] compartilhavam o comando formal.", "Hilotas e reis", {
    "sentenca": "Em Esparta, a elite cidadã dependia do trabalho dos [1], enquanto dois [2] compartilhavam o comando formal.",
    "lacunas": [
        {"ordem": 1, "opcoes": ["hilotas", "metecos", "helots romanos"], "correta": "hilotas"},
        {"ordem": 2, "opcoes": ["reis", "cônsules", "imperadores"], "correta": "reis"},
    ],
    "explicacao": "Os hilotas sustentavam a economia agrária espartana; a diarquia (dois reis) era uma marca institucional de Esparta.",
}))

items.append(_q(2, 3, "linha-do-tempo", "Um pequeno contingente espartano e aliados enfrenta o exército persa em um desfiladeiro.", "Termópilas", {
    "situacao_inicial": "Em 480 a.C., um contingente grego liderado por espartanos ocupa o desfiladeiro das Termópilas diante da invasão persa.",
    "alternativas": [
        "A resistência atrasa os persas e vira símbolo, mas a Grécia continental ainda é invadida",
        "Os persas desistem da invasão e firmam paz imediata com Esparta",
        "Atenas anexa Esparta como recompensa pela vitória",
    ],
    "correta": 0,
    "tipo_relacao": "sequencia",
    "explicacao": "Termópilas foi uma derrota tática heroizada depois; a guerra continuou com Salamina e Plateia.",
}))

items.append(_q(2, 4, "quiz-relampago", "Qual instituição espartana reunia os anciãos aristocráticos?", "Gerúsia", {
    "enunciado": "Qual conselho espartano era formado sobretudo por anciãos e tinha grande peso político?",
    "alternativas": ["Gerúsia", "Eclésia ateniense", "Senado romano", "Areópago apenas"],
    "correta": 0,
    "explicacao": "A gerúsia, com os reis e anciãos, concentrava influência oligárquica em Esparta.",
}, "alta"))

# Sub 3 — conexao, VM, who, timeline
items.append(_q(3, 1, "conexao", "Relacione batalhas e significados.", "Guerras Médicas", {
    "titulo": "De Maratona a Alexandre",
    "subtitulo": "Ligue cada evento ao seu significado.",
    "coluna_esquerda": [
        {"id": "e1", "texto": "Maratona (490 a.C.)"},
        {"id": "e2", "texto": "Salamina (480 a.C.)"},
        {"id": "e3", "texto": "Alexandre no Oriente"},
    ],
    "coluna_direita": [
        {"id": "d1", "texto": "Vitória terrestre ateniense sobre a primeira invasão persa"},
        {"id": "d2", "texto": "Vitória naval que salvou o esforço grego na segunda invasão"},
        {"id": "d3", "texto": "Espalha o mundo helenístico até a Ásia"},
    ],
    "pares": [
        {"esquerda_id": "e1", "direita_id": "d1", "explicacao": "Em Maratona, Atenas (com Plateia) derrotou a força de Dario I."},
        {"esquerda_id": "e2", "direita_id": "d2", "explicacao": "Salamina foi decisiva no mar contra Xerxes."},
        {"esquerda_id": "e3", "direita_id": "d3", "explicacao": "As campanhas de Alexandre criaram o horizonte helenístico."},
    ],
}))

items.append(_q(3, 2, "verdade-mito", "A Guerra do Peloponeso foi uma guerra curta e pouco destrutiva entre Atenas e Esparta.", "Guerra do Peloponeso", {
    "texto": "A Guerra do Peloponeso foi um conflito curto e pouco destrutivo entre Atenas e Esparta.",
    "veredito": "mito",
    "explicacao": "Durou cerca de três décadas (431–404 a.C.), devastou populações, finanças e o sistema de alianças grego.",
}))

items.append(_q(3, 3, "quem-sou-eu", "Quem sou eu?", "Alexandre, o Grande", {
    "header": "Quem sou eu?",
    "dica_1": "Fui rei da Macedônia no século IV a.C.",
    "dica_2": "Derrotei o Império Persa e cheguei até o vale do Indo.",
    "dica_3": "Morri jovem, e meu império foi dividido pelos diádocos.",
    "dica_4": "Minha educação passou por Aristóteles.",
    "resposta_certa": "Alexandre, o Grande",
    "sinonimos_aceitos": ["Alexandre Magno", "Alexandre III", "Alexandre da Macedônia"],
    "explicacao": "Alexandre III da Macedônia construiu um império efêmero que espalhou a cultura helenística.",
}))

items.append(_q(3, 4, "linha-do-tempo", "Esparta vence Atenas na Guerra do Peloponeso.", "Após o Peloponeso", {
    "situacao_inicial": "Em 404 a.C., Atenas capitula diante de Esparta após a Guerra do Peloponeso.",
    "alternativas": [
        "A hegemonia espartana é contestada e a Macedônia se fortalece nas décadas seguintes",
        "Atenas volta a dominar a Grécia sem interrupção por dois séculos",
        "Pérsia anexa todas as pólis gregas imediatamente",
    ],
    "correta": 0,
    "tipo_relacao": "sequencia",
    "explicacao": "A vitória espartana não trouxe ordem duradoura; no século IV a Macedônia ascendeu sob Filipe II.",
}))

# Sub 4 — quiz, palavra, completar, batalha
items.append(_q(4, 1, "quiz-relampago", "Qual magistratura romana era anual e colegiada no topo do cursus?", "Consulado", {
    "enunciado": "Na República romana, qual era a magistratura anual máxima, exercida em geral por dois homens?",
    "alternativas": ["Consulado", "Tribunato da plebe", "Ditadura vitalícia", "Principado"],
    "correta": 0,
    "explicacao": "Os cônsules eram a cúpula ordinária do cursus honorum republicano, com mandato anual e colegialidade.",
}, "alta"))

items.append(_q(4, 2, "palavra_misteriosa", "Assembleia aristocrática que aconselhou e guiou a política romana por séculos.", "Senado", {
    "palavra": "Senado",
    "descricao": "Conselho de anciãos aristocráticos que concentrou a autoridade política na República romana.",
    "dica": "Seus decretos chamavam-se senatus consulta.",
    "explicacao": "O Senado romano foi o centro da política aristocrática republicana e manteve prestígio mesmo no Império.",
}))

items.append(_q(4, 3, "completar_frase", "O conflito entre [1] e [2] na Roma arcaica gerou tribunos e novas leis.", "Patrícios e plebeus", {
    "sentenca": "O conflito entre [1] e [2] na Roma arcaica gerou tribunos da plebe e pressão por leis escritas.",
    "lacunas": [
        {"ordem": 1, "opcoes": ["patrícios", "hilotas", "metecos"], "correta": "patrícios"},
        {"ordem": 2, "opcoes": ["plebeus", "sátrapas", "falanges"], "correta": "plebeus"},
    ],
    "explicacao": "A luta patrício-plebeia redefiniu direitos políticos e o acesso às magistraturas ao longo da República arcaica.",
}))

items.append(_q(4, 4, "batalha", "O que as Doze Tábuas representaram?", "Doze Tábuas", {
    "pergunta": "Qual afirmação melhor descreve as Doze Tábuas?",
    "opcao_a": "Uma codificação escrita que tornava o direito menos exclusivo dos patrícios",
    "opcao_b": "A primeira constituição democrática com voto feminino em Roma",
    "correta": "a",
    "criterio_comparacao": "Significado jurídico das Doze Tábuas",
    "explicacao": "As Doze Tábuas fixaram normas em texto público, limitando o monopólio aristocrático da interpretação costumeira.",
}))

# Sub 5 — VM, who, timeline, quiz
items.append(_q(5, 1, "verdade-mito", "Todos os habitantes livres da Itália romana tinham cidadania plena desde o início da República.", "Cidadania restrita", {
    "texto": "Desde o início da República, todos os habitantes livres da Itália já tinham cidadania romana plena.",
    "veredito": "mito",
    "explicacao": "Havia uma hierarquia de status (cives, socii, etc.). A Guerra Social (91–88 a.C.) explodiu em parte por causa dessa exclusão.",
}))

items.append(_q(5, 2, "quem-sou-eu", "Quem sou eu?", "Tibério Graco", {
    "header": "Quem sou eu?",
    "dica_1": "Fui tribuno da plebe no século II a.C.",
    "dica_2": "Propús reforma agrária para redistribuir terras públicas.",
    "dica_3": "Morri em meio à violência política em Roma.",
    "dica_4": "Meu irmão Caio continuou a linha reformista.",
    "resposta_certa": "Tibério Graco",
    "sinonimos_aceitos": ["Tiberio Graco", "Tibério Semprônio Graco"],
    "explicacao": "Tibério Graco simboliza a crise agrária e a radicalização da política republicana tardia.",
}))

items.append(_q(5, 3, "linha-do-tempo", "Roma vence Cartago nas Guerras Púnicas.", "Após as Púnicas", {
    "situacao_inicial": "Roma derrota Cartago e se torna potência dominante no Mediterrâneo ocidental.",
    "alternativas": [
        "Afluxo de riquezas e escravizados aprofunda desigualdades e crises internas",
        "Roma abandona o exército e desmilitariza a Itália",
        "O Senado dissolve a cidadania romana",
    ],
    "correta": 0,
    "tipo_relacao": "causa_efeito",
    "explicacao": "A vitória imperial gerou botins e mão de obra escrava que desorganizaram a base camponesa-soldado.",
}))

items.append(_q(5, 4, "quiz-relampago", "O que foi a Guerra Social (91–88 a.C.)?", "Guerra Social", {
    "enunciado": "A Guerra Social na República romana foi principalmente um conflito sobre quê?",
    "alternativas": [
        "Direitos e cidadania dos aliados italianos",
        "A sucessão de Alexandre na Ásia",
        "A conversão oficial ao cristianismo",
        "A construção da Muralha de Adriano",
    ],
    "correta": 0,
    "explicacao": "Os socii italianos lutaram por cidadania e igualdade jurídica dentro do sistema romano.",
}, "alta"))

# Sub 6 — conexao, completar, palavra, timeline
items.append(_q(6, 1, "conexao", "Relacione personagens e desfechos.", "Fim da República", {
    "titulo": "César, Augusto e o Principado",
    "subtitulo": "Ligue cada figura ao fato associado.",
    "coluna_esquerda": [
        {"id": "e1", "texto": "Júlio César"},
        {"id": "e2", "texto": "Otaviano/Augusto"},
        {"id": "e3", "texto": "Batalha de Ácio"},
    ],
    "coluna_direita": [
        {"id": "d1", "texto": "Ditadura vitalícia e assassinato nas idos de março"},
        {"id": "d2", "texto": "Fundador do Principado com fachada republicana"},
        {"id": "d3", "texto": "Derrota de Marco Antônio e Cleópatra (31 a.C.)"},
    ],
    "pares": [
        {"esquerda_id": "e1", "direita_id": "d1", "explicacao": "César concentrou poderes e foi morto em 44 a.C."},
        {"esquerda_id": "e2", "direita_id": "d2", "explicacao": "Augusto reorganizou o poder pessoal sob nomes republicanos."},
        {"esquerda_id": "e3", "direita_id": "d3", "explicacao": "Ácio decidiu a guerra civil a favor de Otaviano."},
    ],
}))

items.append(_q(6, 2, "completar_frase", "Otaviano venceu em [1] e recebeu o título de [2].", "Ácio e Augusto", {
    "sentenca": "Otaviano venceu a guerra civil em [1] (31 a.C.) e depois recebeu o título honorífico de [2].",
    "lacunas": [
        {"ordem": 1, "opcoes": ["Ácio", "Maratona", "Canas"], "correta": "Ácio"},
        {"ordem": 2, "opcoes": ["Augusto", "Cônsul vitalício", "Faraó"], "correta": "Augusto"},
    ],
    "explicacao": "Ácio consolidou Otaviano; o cognome Augusto (27 a.C.) marca o novo regime.",
}))

items.append(_q(6, 3, "palavra_misteriosa", "Regime criado por Augusto que mantinha instituições republicanas sob poder pessoal.", "Principado", {
    "palavra": "Principado",
    "descricao": "Forma de governo imperial precoce em que o princeps concentra o poder real sob aparência republicana.",
    "dica": "O primeiro a exercê-lo de modo duradouro foi Augusto.",
    "explicacao": "O Principado é o arranjo político que transforma a República vitoriosa em Império estável.",
}))

items.append(_q(6, 4, "linha-do-tempo", "César é assassinado no Senado.", "Após as idos", {
    "situacao_inicial": "Em março de 44 a.C., César é assassinado por um grupo de senadores.",
    "alternativas": [
        "Seguem novas guerras civis até a vitória de Otaviano",
        "A República aristocrática se restaura intacta por dois séculos",
        "Roma abandona a Itália e move a capital para Atenas",
    ],
    "correta": 0,
    "tipo_relacao": "sequencia",
    "explicacao": "O assassinato não restaurou a República: abriu a fase final das guerras civis.",
}))

# Sub 7 — quiz, VM, who, batalha
items.append(_q(7, 1, "quiz-relampago", "O que a Constitutio Antoniniana (212) fez?", "Edito de Caracala", {
    "enunciado": "A Constitutio Antoniniana de 212 d.C., em termos gerais, fez o quê?",
    "alternativas": [
        "Estendeu a cidadania romana a homens livres do Império",
        "Aboliu a escravidão em todas as províncias",
        "Transferiu a capital para Constantinopla",
        "Proibiu o cristianismo",
    ],
    "correta": 0,
    "explicacao": "Caracala estendeu a cidadania a livres do Império, com forte motivação fiscal e administrativa.",
}, "alta"))

items.append(_q(7, 2, "verdade-mito", "A Pax Romana significou ausência total de guerras e revolta no Império.", "Pax Romana", {
    "texto": "Durante a Pax Romana não houve guerras nem revoltas em todo o Império.",
    "veredito": "mito",
    "explicacao": "Houve estabilidade relativa no Mediterrâneo interno, mas fronteiras violentas e revoltas provinciais continuaram.",
}))

items.append(_q(7, 3, "quem-sou-eu", "Quem sou eu?", "Trajano", {
    "header": "Quem sou eu?",
    "dica_1": "Fui imperador no auge da expansão territorial romana.",
    "dica_2": "Conquistei a Dácia e cheguei a campanhas no Oriente.",
    "dica_3": "Faço parte dos chamados 'bons imperadores' do século II.",
    "resposta_certa": "Trajano",
    "sinonimos_aceitos": ["Marcus Ulpius Traianus", "Imperador Trajano"],
    "explicacao": "Sob Trajano o Império atingiu sua maior extensão territorial.",
}))

items.append(_q(7, 4, "batalha", "O que melhor descreve a vida urbana imperial?", "Cidade romana", {
    "pergunta": "O que era mais típico das cidades romanas no Alto Império?",
    "opcao_a": "Fórum, termas, aquedutos e vida pública monumental",
    "opcao_b": "Ausência total de escravidão e igualdade jurídica plena",
    "correta": "a",
    "criterio_comparacao": "Infraestrutura e sociedade urbana",
    "explicacao": "A urbanização romana combinava infraestrutura pública impressionante com hierarquias sociais rígidas, inclusive escravidão.",
}))

# Sub 8 — palavra, completar, timeline, conexao
items.append(_q(8, 1, "palavra_misteriosa", "Reunião de bispos convocada por Constantino em 325 para disputas doutrinárias.", "Concílio de Niceia", {
    "palavra": "Niceia",
    "descricao": "Concílio de 325 que buscou unidade doutrinária cristã sob patrocínio imperial.",
    "dica": "Tratou especialmente da controvérsia ariana.",
    "explicacao": "Niceia mostra a fusão entre poder imperial e definição da ortodoxia cristã.",
}))

items.append(_q(8, 2, "completar_frase", "Constantino legalizou o cristianismo nos [1]; Teodósio reforçou o cristianismo niceno como [2].", "313 e religião oficial", {
    "sentenca": "Constantino favoreceu a legalização cristã nos editais de [1]; no fim do século IV, Teodósio consolidou o cristianismo niceno como [2].",
    "lacunas": [
        {"ordem": 1, "opcoes": ["313", "476", "27 a.C."], "correta": "313"},
        {"ordem": 2, "opcoes": ["religião oficial", "seita proibida", "culto apenas privado"], "correta": "religião oficial"},
    ],
    "explicacao": "O caminho do cristianismo no Império vai da tolerância/favor constantiniano à oficialização sob Teodósio.",
}))

items.append(_q(8, 3, "linha-do-tempo", "Comunidades cristãs se espalham pelas cidades do Império.", "Cristianismo urbano", {
    "situacao_inicial": "Nos séculos I–III, o cristianismo se difunde principalmente por redes urbanas do Mediterrâneo.",
    "alternativas": [
        "A Igreja herda estruturas urbanas e se torna ator político na Antiguidade Tardia",
        "O Império abandona todas as cidades e volta ao nomadismo",
        "O Senado adota o budismo como culto oficial",
    ],
    "correta": 0,
    "tipo_relacao": "causa_efeito",
    "explicacao": "A geografia urbana do Império foi o suporte material da expansão cristã e do episcopado.",
}))

items.append(_q(8, 4, "conexao", "Relacione medidas e imperadores.", "Império e cristianismo", {
    "titulo": "Cristianismo no Império",
    "subtitulo": "Ligue cada autoridade à medida associada.",
    "coluna_esquerda": [
        {"id": "e1", "texto": "Constantino"},
        {"id": "e2", "texto": "Teodósio"},
        {"id": "e3", "texto": "Perseguições anteriores"},
    ],
    "coluna_direita": [
        {"id": "d1", "texto": "Favorece e legaliza o culto cristão"},
        {"id": "d2", "texto": "Consolida o cristianismo niceno como religião do Império"},
        {"id": "d3", "texto": "Foram intermitentes, não uma caça permanente de três séculos"},
    ],
    "pares": [
        {"esquerda_id": "e1", "direita_id": "d1", "explicacao": "Constantino muda o estatuto político do cristianismo."},
        {"esquerda_id": "e2", "direita_id": "d2", "explicacao": "Teodósio associa Império e ortodoxia nicena."},
        {"esquerda_id": "e3", "direita_id": "d3", "explicacao": "A imagem de perseguição contínua é exagero; houve ondas locais e imperiais."},
    ],
}))

# Sub 9 — VM, who, timeline, quiz
items.append(_q(9, 1, "verdade-mito", "Entre 235 e 284 Roma teve estabilidade dinástica sem crises.", "Anarquia Militar", {
    "texto": "Entre 235 e 284 d.C. o Império Romano viveu estabilidade dinástica sem crises graves.",
    "veredito": "mito",
    "explicacao": "Foi a Anarquia Militar: sucessão caótica de imperadores, invasões, peste e fragmentações regionais.",
}))

items.append(_q(9, 2, "quem-sou-eu", "Quem sou eu?", "Diocleciano", {
    "header": "Quem sou eu?",
    "dica_1": "Reorganizei o Império no fim do século III.",
    "dica_2": "Criei a Tetrarquia para dividir responsabilidades.",
    "dica_3": "Reforcei impostos, burocracia e o cerimonial imperial.",
    "resposta_certa": "Diocleciano",
    "sinonimos_aceitos": ["Diocleciano Augusto"],
    "explicacao": "Diocleciano encerra a pior fase da crise do século III com reformas administrativas e a Tetrarquia.",
}))

items.append(_q(9, 3, "linha-do-tempo", "Imperadores se sucedem em ritmo acelerado no século III.", "Resposta de Diocleciano", {
    "situacao_inicial": "A crise do século III multiplica usurpadores e pressiona fronteiras e moeda.",
    "alternativas": [
        "Diocleciano impõe a Tetrarquia e uma ordem administrativa mais rígida",
        "Roma dissolve as legiões e entrega as fronteiras a Cartago",
        "O Senado restaura a monarquia etrusca",
    ],
    "correta": 0,
    "tipo_relacao": "sequencia",
    "explicacao": "A Tetrarquia foi a resposta institucional à instabilidade do século III.",
}))

items.append(_q(9, 4, "quiz-relampago", "O que foi a Tetrarquia?", "Tetrarquia", {
    "enunciado": "A Tetrarquia de Diocleciano consistia em quê?",
    "alternativas": [
        "Divisão do poder imperial entre quatro governantes",
        "Eleição de quatro cônsules anuais pela plebe",
        "Aliança permanente com quatro pólis gregas",
        "Partilha do Império com a Pérsia",
    ],
    "correta": 0,
    "explicacao": "Dois augustos e dois césares deveriam estabilizar sucessão e defesa.",
}, "alta"))

# Sub 10 — completar, palavra, who, batalha
items.append(_q(10, 1, "completar_frase", "Em [1], Odoacro depõe [2] em Ravena.", "476 e Rômulo Augústulo", {
    "sentenca": "Em [1], Odoacro depõe [2] em Ravena, marco convencional do fim do Império no Ocidente.",
    "lacunas": [
        {"ordem": 1, "opcoes": ["476", "313", "1453"], "correta": "476"},
        {"ordem": 2, "opcoes": ["Rômulo Augústulo", "Augusto", "Justiniano"], "correta": "Rômulo Augústulo"},
    ],
    "explicacao": "476 é um marco didático; a transformação do Ocidente romano foi processo longo.",
}))

items.append(_q(10, 2, "palavra_misteriosa", "Chefe militar que depôs o último imperador do Ocidente em 476.", "Odoacro", {
    "palavra": "Odoacro",
    "descricao": "Líder militar que depôs Rômulo Augústulo e governou a Itália reconhecendo, em tese, Constantinopla.",
    "dica": "Seu ato em 476 virou data escolar da 'queda de Roma'.",
    "explicacao": "Odoacro exemplifica a tomada do poder por chefes romano-germânicos no Ocidente tardio.",
}))

items.append(_q(10, 3, "quem-sou-eu", "Quem sou eu?", "Alarico", {
    "header": "Quem sou eu?",
    "dica_1": "Fui rei visigodo.",
    "dica_2": "Em 410, minha tropa saqueou Roma — um choque simbólico.",
    "dica_3": "Isso aconteceu décadas antes de 476.",
    "resposta_certa": "Alarico",
    "sinonimos_aceitos": ["Alarico I"],
    "explicacao": "O saque de 410 mostrou a fragilidade política de Roma Ocidental muito antes de 476.",
}))

items.append(_q(10, 4, "batalha", "O que 476 representa melhor?", "Significado de 476", {
    "pergunta": "Qual leitura histórica é mais precisa sobre 476?",
    "opcao_a": "Marco conveniente de transição política no Ocidente, não fim absoluto da cultura romana",
    "opcao_b": "Data em que toda a população europeia esqueceu o latim de um dia para o outro",
    "correta": "a",
    "criterio_comparacao": "Interpretação do fim do Império Ocidental",
    "explicacao": "Historiadores tratam 476 como marco simbólico dentro de uma transição longa e desigual.",
}))

# Sub 11 — VM, timeline, conexao, who
items.append(_q(11, 1, "verdade-mito", "Com a deposição de 476, todo o Império Romano deixou de existir.", "Roma Oriental", {
    "texto": "Quando Rômulo Augústulo foi deposto em 476, todo o Império Romano deixou de existir.",
    "veredito": "mito",
    "explicacao": "O Império Romano do Oriente continuou por quase mil anos, até a queda de Constantinopla em 1453.",
}))

items.append(_q(11, 2, "linha-do-tempo", "Justiniano governa em Constantinopla no século VI.", "Obra de Justiniano", {
    "situacao_inicial": "Justiniano tenta restaurar o prestígio romano a partir do Oriente no século VI.",
    "alternativas": [
        "Promove reconquistas parciais no Ocidente e codifica o direito romano",
        "Transfere definitivamente a capital para Londres",
        "Aboliu o cristianismo em todo o Mediterrâneo",
    ],
    "correta": 0,
    "tipo_relacao": "sequencia",
    "explicacao": "Justiniano é lembrado pelo Corpus Juris Civilis e pelas campanhas no Ocidente mediterrânico.",
}))

items.append(_q(11, 3, "conexao", "Relacione espaços e destinos.", "Ocidente e Oriente", {
    "titulo": "Bizâncio e a continuidade",
    "subtitulo": "Ligue cada espaço ao desfecho histórico.",
    "coluna_esquerda": [
        {"id": "e1", "texto": "Império no Ocidente"},
        {"id": "e2", "texto": "Império no Oriente"},
        {"id": "e3", "texto": "Corpus Juris Civilis"},
    ],
    "coluna_direita": [
        {"id": "d1", "texto": "Fragmenta-se em reinos romano-germânicos após o século V"},
        {"id": "d2", "texto": "Persiste até 1453 como Roma cristã oriental"},
        {"id": "d3", "texto": "Codificação jurídica de Justiniano com longa influência"},
    ],
    "pares": [
        {"esquerda_id": "e1", "direita_id": "d1", "explicacao": "O Ocidente político imperial se dissolve em novos reinos."},
        {"esquerda_id": "e2", "direita_id": "d2", "explicacao": "Bizâncio é a continuidade romana oriental."},
        {"esquerda_id": "e3", "direita_id": "d3", "explicacao": "O direito justinianeu moldou tradições jurídicas posteriores."},
    ],
}))

items.append(_q(11, 4, "quem-sou-eu", "Quem sou eu?", "Justiniano", {
    "header": "Quem sou eu?",
    "dica_1": "Governei a partir de Constantinopla no século VI.",
    "dica_2": "Ordenei a grande codificação do direito romano.",
    "dica_3": "Tentei reconquistar partes do antigo Ocidente imperial.",
    "resposta_certa": "Justiniano",
    "sinonimos_aceitos": ["Justiniano I", "Flávio Justiniano"],
    "explicacao": "Justiniano personifica a ambição romana oriental de unidade jurídica e territorial.",
}))

# Sub 12 — completar, palavra, timeline, who
items.append(_q(12, 1, "completar_frase", "As línguas [1] derivam do latim; o imaginário [2] ainda inspira instituições modernas.", "românicas e republicano", {
    "sentenca": "As línguas [1] derivam do latim; o imaginário [2] romano ainda inspira debates políticos modernos.",
    "lacunas": [
        {"ordem": 1, "opcoes": ["românicas", "germânicas", "eslavas apenas"], "correta": "românicas"},
        {"ordem": 2, "opcoes": ["republicano", "samurai", "faraônico"], "correta": "republicano"},
    ],
    "explicacao": "Latim e formas políticas romanas (república, império, cidadania) deixaram heranças duradouras e seletivas.",
}))

items.append(_q(12, 2, "palavra_misteriosa", "Família linguística do português, espanhol, francês, italiano e romeno.", "Línguas românicas", {
    "palavra": "línguas românicas",
    "descricao": "Família de línguas derivadas do latim falado no Império Romano do Ocidente.",
    "dica": "Português, espanhol, francês, italiano e romeno pertencem a ela.",
    "explicacao": "O latim vulgar das províncias evoluiu para as línguas românicas medievais e modernas.",
}, short="As línguas românicas são herdeiras do latim vulgar provincial."))

items.append(_q(12, 3, "linha-do-tempo", "Escolas medievais e modernas leem autores gregos e romanos.", "Legado seletivo", {
    "situacao_inicial": "Séculos depois, elites europeias estudam direito romano, retórica e filosofia antiga.",
    "alternativas": [
        "O legado clássico é reativado de forma seletiva — incluindo exclusões e contradições da Antiguidade",
        "Toda a Europa abandona o alfabeto latino",
        "O estudo de Roma leva à restauração imediata do Império em 800 com as mesmas fronteiras de Trajano",
    ],
    "correta": 0,
    "tipo_relacao": "causa_efeito",
    "explicacao": "Tradições clássicas foram reaproveitadas por projetos políticos e culturais posteriores, nunca como cópia integral.",
}))

items.append(_q(12, 4, "quem-sou-eu", "Quem sou eu?", "Cícero", {
    "header": "Quem sou eu?",
    "dica_1": "Fui orador e político da República romana tardia.",
    "dica_2": "Minhas cartas e discursos viraram modelo de latim e retórica.",
    "dica_3": "Opus-me a Marco Antônio e fui morto na repressão do Segundo Triunvirato.",
    "resposta_certa": "Cícero",
    "sinonimos_aceitos": ["Marco Túlio Cícero", "Cicero"],
    "explicacao": "Cícero é uma ponte clássica entre política republicana, latim literário e tradição retórica ocidental.",
}))

TRAIL["items"] = items
