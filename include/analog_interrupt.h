#ifndef __ANALOG_INTERRUPT_H
#define __ANALOG_INTERRUPT_H

#include "stdint.h"

// extern uint64_t ticks;

enum interrupt_status
{
    INTERRUPT_OFF,
    INTERRUPT_ON
};

/**
 * interrupt_enable - 中断使能
 * **/
void interrupt_enable();

/**
 * interrupt_disable - shield interrupt
 * **/
sigset_t interrupt_disable();

/**
 * interrupt_set - 设阻塞信号集为old_set
 * @old: 要设置的信号集
 * **/
void interrupt_set(sigset_t old_set);

#endif
