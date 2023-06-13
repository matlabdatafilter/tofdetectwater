#pragma once
#include "stdio.h"
#include <cmath>

#ifndef __int8_t_defined  
# define __int8_t_defined  
typedef signed char             int8_t;   
typedef short int               int16_t;  
typedef int                     int32_t;  
# if __WORDSIZE == 64  
typedef long int                int64_t;  
# else  
__extension__  
typedef long long int           int64_t;  
# endif  
#endif  
  
  
typedef unsigned char           uint8_t;  
typedef unsigned short int      uint16_t;  
#ifndef __uint32_t_defined  
typedef unsigned int            uint32_t;  
# define __uint32_t_defined  
#endif  
#if __WORDSIZE == 64  
typedef unsigned long int       uint64_t;  
#else  
__extension__  
typedef unsigned long long int  uint64_t;  
#endif  

/**
 * @brief General Digital Filter. Support no more than 10th orders.
 * @author Zhang Haiyang.
 */
template <typename T>
class DigiFilterBase {
 public:
  T b[11] = {0.};
  T a[11] = {0.};
  T x[11] = {0.};
  T y[11] = {0.};
  int N = 0;
  DigiFilterBase() = default;
  void init(int order, const double num[], const double den[]) {
    if (order < 1 || order > 10) {
      return;
    }
    N = order;
    for (int i = 0; i <= N; i++) {
      b[i] = static_cast<T>(num[i]);
      a[i] = static_cast<T>(den[i]);
    }
  }
  T filter(T val) {
    T y0 = 0.;
    for (uint8_t i = N; i > 0; i--) {
      x[i] = x[i - 1];
      y[i] = y[i - 1];
      y0 += b[i] * x[i] - a[i] * y[i];
    }
    x[0] = val;
    y[0] = y0 + b[0] * x[0];
    return y[0];
  }
  const T &output() const {
    return y[0];
  }
  void reset(T val) {
    for (uint8_t i = 0; i <= N; i++) {
      x[i] = y[i] = val;
    }
  }
};

class TofHpfFilter : public DigiFilterBase<float> {
 public:  // Butter_2nd_10Hz_33sps
  static constexpr int N = 2;
  double num[N + 1] = {0.20169205911526, -0.40338411823052, 0.20169205911526};
  double den[N + 1] = {1, 0.392116929473767, 0.198885165934809};

  TofHpfFilter() { init(N, num, den); }
};

#define WAT_WIN_SIZE 20
#define STAND_DEV_VALUE_THRESHOLD 0.32
#define WATER_CNT_THRESHOLD 30

typedef struct waterdetectflag_s {
float mean = 0;
float variance = 0;
float stdvariance = 0;
float hpf_dpfs;
bool waterflag = false;
bool fly_state_change = false;
} waterdetectflag_t;

typedef struct waterdetectrawdata_s {
bool fly_state_now;
bool fly_state_last = false;
float dpfs_new;
} waterdetectrawdata_t;


class water_detect
{
public:
  waterdetectflag_t tof_water_detect(waterdetectrawdata_t *waterdetectrawdata);
private:
  TofHpfFilter tofdpfsFilter_;
};