import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import '../../domain/models/challenge_stamp.dart';
import '../../infrastructure/repositories/challenge_stamp_repository.dart';

// Main State Provider
final challengeStampViewModelProvider = StateNotifierProvider<ChallengeStampNotifier, AsyncValue<List<ChallengeStamp>>>((ref) {
  final repo = ref.watch(challengeStampRepositoryProvider);
  return ChallengeStampNotifier(repo, ref);
});

// Event Provider for specific completion events (to trigger one-time dialogs)
// Returns the ID of the completed challenge, or null.
final challengeCompletionEventProvider = StateProvider<ChallengeType?>((ref) => null);

class ChallengeStampNotifier extends StateNotifier<AsyncValue<List<ChallengeStamp>>> {
  final ChallengeStampRepository _repository;
  final Ref _ref;

  ChallengeStampNotifier(this._repository, this._ref) : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    state = const AsyncValue.loading();
    try {
      final stamps = await _repository.loadStamps();
      state = AsyncValue.data(stamps);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> complete(int challengeId) async {
    final currentAsync = state;
    if (!currentAsync.hasValue) return; // Not loaded yet
    final currentList = currentAsync.value!;

    final index = currentList.indexWhere((s) => s.type.id == challengeId);
    if (index == -1) return;

    final targetStamp = currentList[index];
    if (targetStamp.isCompleted) return; // Already completed

    // Update State
    final updatedStamp = targetStamp.copyWith(
      isCompleted: true,
      completedAt: DateTime.now(),
    );
    
    // Optimistic update
    final updatedList = List<ChallengeStamp>.from(currentList);
    updatedList[index] = updatedStamp;
    state = AsyncValue.data(updatedList);

    // Save to persistence
    try {
      await _repository.saveStamp(updatedStamp);
      
      // Trigger Event
      _ref.read(challengeCompletionEventProvider.notifier).state = updatedStamp.type;
       
       // Clear event after a short delay (or let UI consume it)
       // Better pattern: UI listens, consumes, and we don't auto-clear or we clear on consumption.
       // Here we rely on the StateProvider updating. If same challenge completed again (impossible due to check above), it wouldn't fire.
    } catch (e) {
      // Revert if save failed? For stamps, maybe not critical, but good practice.
      _load(); 
    }
  }
  
  // Debug method to reset
  Future<void> reset() async {
    await _repository.reset();
    await _load();
  }
}
