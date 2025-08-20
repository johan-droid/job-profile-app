import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../utils/user_type.dart';
import '../../responsive_layout.dart';

class UserSelectionScreen extends StatefulWidget {
  final Function(UserType) onUserTypeSelected;
  final UserType initialSelection;

  const UserSelectionScreen({
    Key? key,
    required this.onUserTypeSelected,
    this.initialSelection = UserType.student,
  }) : super(key: key);

  @override
  State<UserSelectionScreen> createState() => _UserSelectionScreenState();
}

class _UserSelectionScreenState extends State<UserSelectionScreen>
    with SingleTickerProviderStateMixin {
  late UserType _selectedUserType;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _selectedUserType = widget.initialSelection;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobile: _buildMobileLayout(),
        tablet: _buildTabletLayout(),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          _buildHeader(),
          const SizedBox(height: 40),
          _buildRoleSelector(),
          const SizedBox(height: 40),
          _buildContinueButton(),
          const Spacer(),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return SafeArea(
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: _getRoleColor(_selectedUserType),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: 150,
                      width: 150,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          _getRoleIcon(_selectedUserType),
                          size: 100,
                          color: Colors.white,
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'AI-Powered Talent Bridge',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            offset: const Offset(1, 1),
                            blurRadius: 3.0,
                            color: Colors.black.withOpacity(0.3),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Choose your role to get started',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildRoleSelector(),
                const SizedBox(height: 40),
                _buildContinueButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          Icon(
            _getRoleIcon(_selectedUserType),
            size: 60,
            color: _getRoleColor(_selectedUserType),
          ),
          const SizedBox(height: 16),
          Text(
            'Choose Your Role',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: _getRoleColor(_selectedUserType),
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Select the option that best describes you',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            _buildRoleOption(
              title: 'Student',
              description: 'Find opportunities and build your career',
              icon: Icons.school,
              type: UserType.student,
            ),
            const SizedBox(height: 16),
            _buildRoleOption(
              title: 'Employer',
              description: 'Post jobs and find talented students',
              icon: Icons.business,
              type: UserType.employer,
            ),
            const SizedBox(height: 16),
            _buildRoleOption(
              title: 'University',
              description: 'Track placements and analyze outcomes',
              icon: Icons.account_balance,
              type: UserType.university,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleOption({
    required String title,
    required String description,
    required IconData icon,
    required UserType type,
  }) {
    final isSelected = _selectedUserType == type;
    final color = _getRoleColor(type);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected ? color.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? color : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedUserType = type;
          });
        },
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isSelected ? color : color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : color,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? color : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: color,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              widget.onUserTypeSelected(_selectedUserType);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _getRoleColor(_selectedUserType),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: const Text(
              'Continue',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                // Navigate back if needed
                Navigator.pop(context);
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRoleColor(UserType type) {
    switch (type) {
      case UserType.student:
        return AppTheme.primaryColor;
      case UserType.employer:
        return AppTheme.secondaryColor;
      case UserType.university:
        return AppTheme.neutralColor.withBlue(100);
    }
  }

  IconData _getRoleIcon(UserType type) {
    switch (type) {
      case UserType.student:
        return Icons.school;
      case UserType.employer:
        return Icons.business;
      case UserType.university:
        return Icons.account_balance;
    }
  }
}
