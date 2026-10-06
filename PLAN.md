# Plan

## Phase 1: Setup
- Confirm with TA: Fitness/Stress carried over from Lab 1?
- Agree serial format with hardware team (`ecg,resp` + leads-off flag)
- Rename UI folder / main sketch to match
- Wire `Mock.pde` into a new main sketch via `onSample()`

## Phase 2: Signal processing
- ECG bandpass + notch filter
- ECG peak detection -> HR
- Respiration smoothing
- Respiration peak/trough detection -> RR, inhale and exhale durations

## Phase 3: Core UI
- Port Lab 1 layout, theme, cards
- ECG graph
- Respiration graph
- Cardio zone graph
- Mode selector (Fitness / Stress / Meditation)
- Age entry

## Phase 4: Modes
- 30 s baseline (resting HR + RR) in every mode
- Fitness: zones (fix thresholds), time-in-zone, per-zone RR + inhale/exhale
- Stress: stressed vs calm detection using HR + RR
- Meditation: inhale = 1/3 exhale check, indicator after 3 bad breaths

## Phase 5: Hardware integration
- Replace mock with real serial input
- Tune thresholds and filters on real data
- Test on all three modes with the strap

## Phase 6: Extras and polish
- Section IV creative feature
- Build UI #2 (polished, second computer)

## Phase 7: Deliverables
- UI sketch for report
- AI usage notes + full chat history
- Demo walkthrough of both UIs
