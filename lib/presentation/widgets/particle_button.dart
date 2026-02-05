import 'dart:math';
import 'package:flutter/material.dart';

class ParticleButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final Color particleColor;

  const ParticleButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.particleColor = const Color(0xFFFFD700), // Gold
  });

  @override
  State<ParticleButton> createState() => _ParticleButtonState();
}

class _ParticleButtonState extends State<ParticleButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _controller.addListener(_updateParticles);
  }

  void _updateParticles() {
    if (_particles.length < 20 && _random.nextDouble() > 0.8) {
      _particles.add(_Particle(_random));
    }

    for (var i = _particles.length - 1; i >= 0; i--) {
      _particles[i].update();
      if (_particles[i].life <= 0) {
        _particles.removeAt(i);
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          CustomPaint(
            painter: _ParticlePainter(_particles, widget.particleColor),
            child: const SizedBox(width: 50, height: 50), // Area for particles
          ),
          widget.child,
        ],
      ),
    );
  }
}

class _Particle {
  double x;
  double y;
  double vx;
  double vy;
  double life;
  double size;

  _Particle(Random random)
      : x = (random.nextDouble() - 0.5) * 40, 
        y = (random.nextDouble() - 0.5) * 20,
        vx = (random.nextDouble() - 0.5) * 1.5,
        vy = (random.nextDouble() - 0.5) * 1.5 - 1.0, // Slight upward drift
        life = 1.0,
        size = random.nextDouble() * 3 + 1;

  void update() {
    x += vx;
    y += vy;
    life -= 0.05;
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final Color color;

  _ParticlePainter(this.particles, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    // Center point
    final cx = size.width / 2;
    final cy = size.height / 2;

    for (final particle in particles) {
      paint.color = color.withOpacity((particle.life).clamp(0.0, 1.0));
      canvas.drawCircle(
        Offset(cx + particle.x, cy + particle.y),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
