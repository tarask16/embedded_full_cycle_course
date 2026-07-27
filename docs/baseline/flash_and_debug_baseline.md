## Deferred hardware timing measurement

Полная аппаратная задержка NRST release → main не измерена.

Причина: на момент выполнения урока отсутствует доступ к линии
аппаратного reset и логическому анализатору/осциллографу.

Подтверждён внутренний интервал:
DWT start inside Reset_Handler → DWT sample at main entry.

Результат:
- Samples: 11
- Minimum: 289 cycles
- Maximum: 289 cycles
- Average: 289.0 cycles
- Spread: 0 cycles

Ограничение:
значение 289 cycles не является полной reset-to-main latency и не
включает интервал от отпускания NRST до запуска DWT.

Аппаратное измерение переносится до появления доступа к оборудованию.