/// Copy and media for the two-slide welcome carousel (web `Onboarding.tsx`).
class OnboardingSlide {
  const OnboardingSlide({
    required this.title,
    required this.body,
    required this.alt,
    this.imageAsset,
    this.showGamification = false,
  });

  final String title;
  final String body;
  final String alt;
  final String? imageAsset;
  final bool showGamification;
}

const onboardingSlides = [
  OnboardingSlide(
    title: 'Você aprende pouco e esquece rápido ⚡',
    body:
        'A maioria das pessoas não tem tempo — nem paciência — pra sentar e estudar. O resultado? Um repertório raso, que não acompanha as conversas que importam. O Lume resolve isso em 5 minutos por dia.',
    imageAsset: 'assets/onboarding/slide-1.jpg',
    alt: 'Ilustração representando esquecimento e aprendizado raso',
  ),
  OnboardingSlide(
    title: 'Trilhas, revisões e jogos pra você chegar ao topo 🏆',
    body:
        'Desbloqueie trilhas de História, Filosofia, Arte, Ciência, Música, Literatura, Geografia e muito mais. Fixe o conteúdo em quizzes de revisão. Jogue Quiz Relâmpago, Verdade ou Mito e Batalha de Curiosidades. Ganhe XP, suba de nível e chegue ao nível máximo enquanto constrói um repertório que enriquece sua vida.',
    alt: 'Ilustração de gamificação com barra de XP, troféu e estrelas',
    showGamification: true,
  ),
];
