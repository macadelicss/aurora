#include "mqtt.h"

VALUE rb_mMqtt;

void
Init_mqtt(void)
{
  rb_mMqtt = rb_define_module("Mqtt");
}
