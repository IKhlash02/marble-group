class DivisionProblem {
  final int dividend;
  final int divisor;
  final int answer;

  DivisionProblem({
    required this.dividend,
    required this.divisor,
    required this.answer,
  });
}

List<DivisionProblem> problems = [
  DivisionProblem(dividend: 24, divisor: 3, answer: 8),
  DivisionProblem(dividend: 15, divisor: 5, answer: 3),
  DivisionProblem(dividend: 20, divisor: 4, answer: 5),
];

