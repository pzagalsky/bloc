import 'package:test/test.dart';
import 'package:bloc/bloc.dart';
import 'package:mockito/mockito.dart';

import './helpers/helpers.dart';

class MockBlocDelegate extends Mock implements BlocDelegate {}

void main() {
  group('onTransition', () {
    test('is called when delegate is provided', () {
      final delegate = MockBlocDelegate();
      final complexBloc = ComplexBloc();
      final List<ComplexState> expectedStateAfterEventB = [
        ComplexStateA(),
        ComplexStateB(),
      ];
      BlocSupervisor().delegate = delegate;
      when(delegate.onTransition(any, any)).thenReturn(null);

      expectLater(
        complexBloc.state,
        emitsInOrder(expectedStateAfterEventB),
      ).then((dynamic _) {
        verify(
          delegate.onTransition(
            complexBloc,
            Transition<ComplexEvent, ComplexState>(
              currentState: ComplexStateA(),
              event: ComplexEventB(),
              nextState: ComplexStateB(),
            ),
          ),
        ).called(1);
      });

      complexBloc.dispatch(ComplexEventB());
    });

    test('is called when delegate is provided for multiple blocs', () {
      final delegate = MockBlocDelegate();
      final complexBlocA = ComplexBloc();
      final complexBlocB = ComplexBloc();
      final List<ComplexState> expectedStateAfterEventB = [
        ComplexStateA(),
        ComplexStateB()
      ];
      final List<ComplexState> expectedStateAfterEventC = [
        ComplexStateA(),
        ComplexStateC()
      ];
      BlocSupervisor().delegate = delegate;
      when(delegate.onTransition(any, any)).thenReturn(null);

      expectLater(
        complexBlocA.state,
        emitsInOrder(expectedStateAfterEventB),
      ).then((dynamic _) {
        verify(
          delegate.onTransition(
            complexBlocA,
            Transition<ComplexEvent, ComplexState>(
              currentState: ComplexStateA(),
              event: ComplexEventB(),
              nextState: ComplexStateB(),
            ),
          ),
        ).called(1);
      });

      expectLater(
        complexBlocB.state,
        emitsInOrder(expectedStateAfterEventC),
      ).then((dynamic _) {
        verify(
          delegate.onTransition(
            complexBlocB,
            Transition<ComplexEvent, ComplexState>(
              currentState: ComplexStateA(),
              event: ComplexEventC(),
              nextState: ComplexStateC(),
            ),
          ),
        ).called(1);
      });

      complexBlocA.dispatch(ComplexEventB());
      complexBlocB.dispatch(ComplexEventC());
    });

    test('is not called when delegate is not provided', () {
      final delegate = MockBlocDelegate();
      final complexBloc = ComplexBloc();
      final List<ComplexState> expectedStateAfterEventB = [
        ComplexStateA(),
        ComplexStateB()
      ];
      BlocSupervisor().delegate = null;
      when(delegate.onTransition(any, any)).thenReturn(null);

      expectLater(
        complexBloc.state,
        emitsInOrder(expectedStateAfterEventB),
      ).then((dynamic _) {
        verifyNever(
          delegate.onTransition(
            complexBloc,
            Transition<ComplexEvent, ComplexState>(
              currentState: ComplexStateA(),
              event: ComplexEventB(),
              nextState: ComplexStateB(),
            ),
          ),
        );
      });

      complexBloc.dispatch(ComplexEventB());
    });
  });
}
